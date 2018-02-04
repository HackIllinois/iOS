//
//  HIAnnouncementDataSource.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/24/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import CoreData

final class HIAnnouncementDataSource {

    static var isRefreshing = false

    static let announcementsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Announcement")
    static let announcementsBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: announcementsFetchRequest)

    static func refresh(completion: (() -> Void)? = nil) {
        guard !isRefreshing else {
            completion?()
            return
        }
        isRefreshing = true
        let backgroundContext = CoreDataController.shared.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        HIAnnouncementService.getAllAnnouncements()
        .onCompletion { result in
            switch result {
            case .success(let containedAnnouncements):
                do {
                    try backgroundContext.execute(announcementsBatchDeleteRequest)
                } catch {
                    completion?()
                    isRefreshing = false
                    return
                }

                backgroundContext.performAndWait {
                    containedAnnouncements.data.forEach { announcement in
                        _ = Announcement(context: backgroundContext, announcement: announcement)
                    }
                }
                try? backgroundContext.save()

            case .cancellation, .failure:
                break
            }
            completion?()
            isRefreshing = false
        }
        .authorization(HIApplicationStateController.shared.user)
        .perform()
    }
}
