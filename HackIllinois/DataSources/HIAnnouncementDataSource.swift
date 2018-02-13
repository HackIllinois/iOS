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

    static let announcementsFetchRequest = NSFetchRequest<Announcement>(entityName: "Announcement")

    static func refresh(completion: (() -> Void)? = nil) {
        guard !isRefreshing else {
            completion?()
            return
        }
        isRefreshing = true

        HIAnnouncementService.getAllAnnouncements()
        .onCompletion { result in
            switch result {
            case .success(let containedAnnouncements):
                DispatchQueue.main.sync {
                    do {
                        let ctx = CoreDataController.shared.persistentContainer.viewContext
                        try? ctx.fetch(announcementsFetchRequest).forEach {
                            ctx.delete($0)
                        }
                        containedAnnouncements.data.forEach {
                            _ = Announcement(context: ctx, announcement: $0)
                        }
                        try ctx.save()
                    } catch { }
                }

            case .cancellation:
                break

            case .failure(let error):
                print("error", error)
            }
            completion?()
            isRefreshing = false
        }
        .authorization(HIApplicationStateController.shared.user)
        .perform()
    }
}
