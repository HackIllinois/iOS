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

    static func refresh(completion: (() -> Void)? = nil) {
        guard !isRefreshing else {
            completion?()
            return
        }
        isRefreshing = true
        
        print("ENTERING::ANNOUNCEMENTS")
        print(HIApplicationStateController.shared.user)
        
        HIAPI.AnnouncementService.getAllAnnouncements()
                .onCompletion { result in
                    do {
                        print("Complete::announcements:: \(result)")
                        let (containedAnnouncements, _) = try result.get()
                            HICoreDataController.shared.performBackgroundTask { context -> Void in
                                do {
                                    //Unwrap contained data
                                    
                                    print("CONTAINED::ANNOUNCEMENTS::\(containedAnnouncements)")
                                    let apiAnnouncements = containedAnnouncements.announcements

                                    let announcementFetchRequest = NSFetchRequest<Announcement>(entityName: "Announcement")
                                    
                                    print("ANNOUNCEMENT::FETCH::REQ \(announcementFetchRequest)")
                                    
                                    let coreDataAnnouncements = try context.fetch(announcementFetchRequest)
                                    
                                    print("Core::data::announcements\(coreDataAnnouncements)") //Announcements are empty for some reason
                                    

                                    print("before::diff")
                                    //8) Diff the CoreData events and API events.
                                    let (
                                        coreDataAnnouncementsToDelete,
                                        coreDataAnnouncementsToUpdate,
                                        apiAnnouncementsToInsert
                                    ) = diff(initial: coreDataAnnouncements, final: apiAnnouncements)

                                    print("after::diff")
                                    // 9) Apply the diff
                                    coreDataAnnouncementsToDelete.forEach { coreDataAnnouncement in
                                        // Delete CoreData Announcement.
                                        context.delete(coreDataAnnouncement)
                                    }
                                    
                                    print("deleting::announcement")

                                    coreDataAnnouncementsToUpdate.forEach { (coreDataAnnouncement, apiAnnouncement) in
                                        // Update CoreData Announcement.
                                        coreDataAnnouncement.title = apiAnnouncement.title
                                        coreDataAnnouncement.info = apiAnnouncement.info
                                        coreDataAnnouncement.time = apiAnnouncement.time
                                        coreDataAnnouncement.topicName = apiAnnouncement.topicName
                                    }
                                    
                                    print("updating::announcement")
                                    print(apiAnnouncementsToInsert)
                                    
                                    //Breaking::here
                                    apiAnnouncementsToInsert.forEach { apiAnnouncement in
                                        // Create CoreData announcement.
                                        print("announcement::made")
                                        let coreDataAnnouncement = Announcement(context: context)
                                        print("announcement::finished")
                                        print("CD::Announcement \(coreDataAnnouncement)")
                                        coreDataAnnouncement.time = apiAnnouncement.time
                                        coreDataAnnouncement.topicName = apiAnnouncement.topicName
                                        coreDataAnnouncement.info = apiAnnouncement.info
                                        coreDataAnnouncement.title = apiAnnouncement.title
                                    }

                                    print("Reaching::save")
                                    // 10) Save changes, call completion handler, unlock refresh
                                    try context.save()
                                    completion?()
                                    isRefreshing = false
                                } catch {
                                    completion?()
                                    isRefreshing = false
                                    print(error)
                                    print("CAUGHT::ERROR")
                                    fatalError("fuck")
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
