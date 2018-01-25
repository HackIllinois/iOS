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

    static func refresh(completion: (() -> Void)? = nil) {
        guard !isRefreshing else {
            completion?()
            return
        }
        isRefreshing = true
        let backgroundContext = CoreDataController.shared.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

        HIAnnouncementService.getAllAnnouncements()
        .onCompletion { result in
            switch result {
            case .success(let containedAnnouncements):
                // TODO: only remove all announcements
                backgroundContext.reset()

                backgroundContext.performAndWait {
                    containedAnnouncements.data.forEach { announcement in
                        _ = Announcement(context: backgroundContext, announcement: announcement)
                    }
                }
                try? backgroundContext.save()

            case .cancellation:
                break
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                completion?()
                isRefreshing = false
            }
        }
        .perform()
    }
}
