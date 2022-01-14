//
//  HIProfileDataSource.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/25/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import CoreData
import HIAPI
import os

final class HIProfileDataSource {

    // Serializes access to isRefreshing.
    private static let isRefreshingQueue = DispatchQueue(label: "org.hackillinois.org.hi_profile_data_source.is_refreshing_queue", attributes: .concurrent)
    // Tracks if the DataSource is refreshing.
    private static var _isRefreshing = false
    // Setter and getter for isRefreshing.
    public static var isRefreshing: Bool {
        get { return isRefreshingQueue.sync { _isRefreshing } }
        set { isRefreshingQueue.sync(flags: .barrier) { _isRefreshing = newValue } }
    }

    static func refresh(completion: (() -> Void)? = nil) {
        guard !isRefreshing else {
            completion?()
            return
        }
        isRefreshing = true

        HIAPI.ProfileService.getLeaderboard(num: HIConstants.LEADERBOARD_PROFILE_LIMIT)
        .onCompletion { result in
            do {
                let (containedProfiles, _) = try result.get()
                HICoreDataController.shared.performBackgroundTask { context -> Void in
                    do {
                        // 1) Unwrap contained data
                        let apiProfiles = containedProfiles.profiles
                        // 2) Get all CoreData profiles.
                        let leaderboardProfileFetchRequest = NSFetchRequest<LeaderboardProfile>(entityName: "LeaderboardProfile")
                        let coreDataLeaderboardProfiles = try context.fetch(leaderboardProfileFetchRequest)
                        // 3) Diff the CoreData profiles and API profiles.
                        let (
                            coreDataProfilesToDelete,
                            coreDataProfilesToUpdate,
                            apiProfilesToInsert
                        ) = diff(initial: coreDataLeaderboardProfiles, final: apiProfiles)
                        // 4) Apply diff
                        coreDataProfilesToDelete.forEach { coreDataProfile in
                            // Delete CoreData location.
                            context.delete(coreDataProfile)
                        }
                        coreDataProfilesToUpdate.forEach { (coreDataProfile, apiProfile) in
                            // Update CoreData profile.
                            coreDataProfile.id = apiProfile.id
                            coreDataProfile.firstName = apiProfile.firstName
                            coreDataProfile.lastName = apiProfile.lastName
                            coreDataProfile.points = Int32(apiProfile.points)
                        }

                        apiProfilesToInsert.forEach { apiProfile in
                            // Create CoreData profile.
                            let coreDataProfile = LeaderboardProfile(context: context)
                            coreDataProfile.id = apiProfile.id
                            coreDataProfile.firstName = apiProfile.firstName
                            coreDataProfile.lastName = apiProfile.lastName
                            coreDataProfile.points = Int32(apiProfile.points)
                        }

                        // 5) Save changes, call completion handler, unlock refresh
                        try context.save()
                        completion?()
                        isRefreshing = false
                    } catch {
                        os_log(
                            "Error getting profiles catch #1: %s",
                            log: Logger.ui,
                            type: .error,
                            String(describing: error)
                        )
                        completion?()
                        isRefreshing = false
                    }
                }
            } catch {
                os_log(
                    "Error getting profiles catch #2: %s",
                    log: Logger.ui,
                    type: .error,
                    String(describing: error)
                )
                completion?()
                isRefreshing = false
            }
        }
        .authorize(with: HIApplicationStateController.shared.user)
        .launch()
    }
}
