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

    static var isRefreshing = false

    static let announcementsFetchRequest = NSFetchRequest<Announcement>(entityName: "Announcement")

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
                                    //Unwrap contained data
                                    let apiAnnouncements = containedAnnouncements.announcements

                                    let announcementFetchRequest = NSFetchRequest<Announcement>(entityName: "Announcement")

                                    let coreDataAnnouncements = try context.fetch(announcementFetchRequest)

                                    //8) Diff the CoreData events and API events.
                                    let (
                                        coreDataAnnouncementsToDelete,
                                        coreDataAnnouncementsToUpdate,
                                        apiAnnouncementsToInsert
                                    ) = diff(initial: coreDataAnnouncements, final: apiAnnouncements)

                                    // 9) Apply the diff
                                    coreDataAnnouncementsToDelete.forEach { coreDataAnnouncement in
                                        // Delete CoreData Announcement.
                                        context.delete(coreDataAnnouncement)
                                    }

                                    coreDataAnnouncementsToUpdate.forEach { (coreDataAnnouncement, apiAnnouncement) in
                                        // Update CoreData Announcement.
                                        coreDataAnnouncement.title = apiAnnouncement.title
                                        coreDataAnnouncement.info = apiAnnouncement.info
                                        coreDataAnnouncement.time = apiAnnouncement.time
                                        coreDataAnnouncement.topicName = apiAnnouncement.topicName
                                    }

                                    apiAnnouncementsToInsert.forEach { apiAnnouncement in
                                        // Create CoreData announcement.
                                        let coreDataAnnouncement = Announcement(context: context)
                                       coreDataAnnouncement.time = apiAnnouncement.time
                                        coreDataAnnouncement.topicName = apiAnnouncement.topicName
                                        coreDataAnnouncement.info = apiAnnouncement.info
                                        coreDataAnnouncement.title = apiAnnouncement.title
                                    }


                                    // 10) Save changes, call completion handler, unlock refresh
                                    try context.save()
                                    completion?()
                                    isRefreshing = false
                                } catch {
                                    completion?()
                                    isRefreshing = false
                                    fatalError("lol")
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
