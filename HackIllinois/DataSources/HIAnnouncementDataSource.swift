//
//  HIAnnouncementDataSource.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/24/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
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

        HIAnnouncementService
            .getAllAnnouncements()
            .onCompletion { result in
                DispatchQueue.main.sync {
                    do {
                        let (containedAnnouncements, _) = try result.get()
                        let ctx = CoreDataController.shared.persistentContainer.viewContext
                        try? ctx.fetch(announcementsFetchRequest).forEach {
                            ctx.delete($0)
                        }
                        containedAnnouncements.data.forEach {
                            _ = Announcement(context: ctx, announcement: $0)
                        }
                        try ctx.save()
                    } catch {
                        print("error", error)
                    }
                }
                completion?()
                isRefreshing = false
            }
            .authorize(with: HIApplicationStateController.shared.user)
            .launch()
    }
}
