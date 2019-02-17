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

final class HIAnnouncementDataSource {

    // Serializes access to isRefreshing.
    private static let isRefreshineQueue = DispatchQueue(label: "org.hackillinois.org.hi_announcement_data_source.is_refreshing_queue", attributes: .concurrent)
    // Tracks if the DataSource is refreshing.
    private static var _isRefreshing = false
    // Setter and getter for isRefreshing.
    public static var isRefreshing: Bool {
        get { return isRefreshineQueue.sync { _isRefreshing } }
        set { isRefreshineQueue.sync(flags: .barrier) { _isRefreshing = newValue } }
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
                                coreDataAnnouncement.info = apiAnnouncement.body
                                coreDataAnnouncement.time = apiAnnouncement.time
                                coreDataAnnouncement.roles = Int32(apiAnnouncement.roles.rawValue)
                            }

                            apiAnnouncementsToInsert.forEach { apiAnnouncement in
                                // Create CoreData announcement.
                                let coreDataAnnouncement = Announcement(context: context)
                                coreDataAnnouncement.time = apiAnnouncement.time
                                coreDataAnnouncement.info = apiAnnouncement.body
                                coreDataAnnouncement.title = apiAnnouncement.title
                                coreDataAnnouncement.roles = Int32(apiAnnouncement.roles.rawValue)
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
}
