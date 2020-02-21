//
//  HIAnnouncementDataSource.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/24/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import CoreData
import HIAPI
import UserNotifications

final class HIAnnouncementDataSource {

    // Serializes access to isRefreshing.
    private static let isRefreshingQueue = DispatchQueue(label: "org.hackillinois.org.hi_announcement_data_source.is_refreshing_queue", attributes: .concurrent)
    // Tracks if the DataSource is refreshing.
    private static var _isRefreshing = false
    // Setter and getter for isRefreshing.
    public static var isRefreshing: Bool {
        get { return isRefreshingQueue.sync { _isRefreshing } }
        set { isRefreshingQueue.sync(flags: .barrier) { _isRefreshing = newValue } }
    }

    // Waive swiftlint warning
    // swiftlint:disable:next function_body_length
    static func refresh(completion: (() -> Void)? = nil) {
        guard !isRefreshing else {
            completion?()
            return
        }
        isRefreshing = true

        HIAPI.AnnouncementService.getAllAnnouncements()
        .onCompletion { result in
            do {
                let (containedAnnouncements, _) = try result.get()
                HICoreDataController.shared.performBackgroundTask { context -> Void in
                    do {
                        // 1) Unwrap contained data.
                        let apiAnnouncements = containedAnnouncements.announcements

                        // 2) Get all CoreData announcements.
                        let announcementFetchRequest = NSFetchRequest<Announcement>(entityName: "Announcement")
                        let coreDataAnnouncements = try context.fetch(announcementFetchRequest)

                        // 3) Diff the CoreData events and API events.
                        let (
                            coreDataAnnouncementsToDelete,
                            coreDataAnnouncementsToUpdate,
                            apiAnnouncementsToInsert
                        ) = diff(initial: coreDataAnnouncements, final: apiAnnouncements)

                        // 4) Apply the diff
                        coreDataAnnouncementsToDelete.forEach { coreDataAnnouncement in
                            // Delete CoreData Announcement.
                            context.delete(coreDataAnnouncement)
                        }

                        coreDataAnnouncementsToUpdate.forEach { (coreDataAnnouncement, apiAnnouncement) in
                            // Update CoreData Announcement.
                            coreDataAnnouncement.title = apiAnnouncement.title
                            coreDataAnnouncement.body = apiAnnouncement.body
                            coreDataAnnouncement.time = apiAnnouncement.time
                            coreDataAnnouncement.topic = apiAnnouncement.topic
                        }

                        apiAnnouncementsToInsert.forEach { apiAnnouncement in
                            // Create CoreData announcement.
                            let coreDataAnnouncement = Announcement(context: context)
                            coreDataAnnouncement.title = apiAnnouncement.title
                            coreDataAnnouncement.body = apiAnnouncement.body
                            coreDataAnnouncement.time = apiAnnouncement.time
                            coreDataAnnouncement.topic = apiAnnouncement.topic
                        }

                        // 10) Save changes, call completion handler, unlock refresh
                        try context.save()
                        completion?()
                        isRefreshing = false
                    } catch {
                        completion?()
                        isRefreshing = false
                    }
                }
            } catch {
                completion?()
                isRefreshing = false
            }
        }
        .authorize(with: HIApplicationStateController.shared.user)
        .launch()
    }

    // decode data from payload and inject into coredata
    static func injectAnnouncement(notification: UNNotification) {
        // 1) Extract the announcement data.
        guard let data = notification.request.content.userInfo["data"] as? [String: Any],
            let title = data["title"] as? String,
            let body = data["body"] as? String,
            let seconds = data["time"] as? TimeInterval,
            let role = data["topic"] as? String,
            let topic = try? HIAPI.Roles(string: role) else { return }
            let time = Date(timeIntervalSince1970: seconds)

        HICoreDataController.shared.performBackgroundTask { context -> Void in
            do {
                // 1) Get all CoreData announcements.
                let announcementFetchRequest = NSFetchRequest<Announcement>(entityName: "Announcement")
                announcementFetchRequest.predicate = NSPredicate(format: "time == %@", time as NSDate)
                let coreDataAnnouncements = try context.fetch(announcementFetchRequest)

                // 2) Update the announcement if it exists, otherwise create it.
                let coreDataAnnouncement = coreDataAnnouncements.first ?? Announcement(context: context)
                coreDataAnnouncement.title = title
                coreDataAnnouncement.body = body
                coreDataAnnouncement.time = time
                coreDataAnnouncement.topic = Int32(topic.rawValue)

                // 3) Save changes, call completion handler.
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}
