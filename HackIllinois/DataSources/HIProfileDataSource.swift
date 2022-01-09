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

    // Waive swiftlint warning
    // swiftlint:disable:next function_body_length
    
    /*
    static func refresh(teamStatus: [String] = [], interests: [String] = [], completion: (() -> Void)? = nil) {
        guard !isRefreshing else {
            completion?()
            return
        }
        isRefreshing = true

        HIAPI.ProfileService.getMatchingProfiles(teamStatus: teamStatus, interests: interests)
        .onCompletion { result in
            do {
                let (containedProfiles, _) = try result.get()
                HICoreDataController.shared.performBackgroundTask { context -> Void in
                    do {
                        // 1) Unwrap contained data
                        let apiProfiles = containedProfiles.profiles

                        // 2) Get all CoreData profiles.
                        let profileFetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
                        let coreDataProfiles = try context.fetch(profileFetchRequest)

                        // 3) Diff the CoreData profiles and API profiles.
                        let (
                            coreDataProfilesToDelete,
                            coreDataProfilesToUpdate,
                            apiProfilesToInsert
                        ) = diff(initial: coreDataProfiles, final: apiProfiles)

                        // 4) Apply the diff
                        coreDataProfilesToDelete.forEach { coreDataProfile in
                            // Delete CoreData profile.
                            context.delete(coreDataProfile)
                        }

                        coreDataProfilesToUpdate.forEach { (coreDataProfile, apiProfile) in
                            // Update CoreData profile.
                            coreDataProfile.id = apiProfile.id
                            coreDataProfile.firstName = apiProfile.firstName
                            coreDataProfile.lastName = apiProfile.lastName
                            coreDataProfile.points = Int32(apiProfile.points)
                            coreDataProfile.timezone = apiProfile.timezone
                            coreDataProfile.info = apiProfile.info
                            coreDataProfile.discord = apiProfile.discord
                            coreDataProfile.avatarUrl = apiProfile.avatarUrl
                            coreDataProfile.teamStatus = apiProfile.teamStatus
                            coreDataProfile.interests = apiProfile.interests.joined(separator: ",")
                            coreDataProfile.favorite = false
                        }

                        apiProfilesToInsert.forEach { apiProfile in
                            // Create CoreData profile.
                            let coreDataProfile = Profile(context: context)
                            coreDataProfile.id = apiProfile.id
                            coreDataProfile.firstName = apiProfile.firstName
                            coreDataProfile.lastName = apiProfile.lastName
                            coreDataProfile.points = Int32(apiProfile.points)
                            coreDataProfile.timezone = apiProfile.timezone
                            coreDataProfile.info = apiProfile.info
                            coreDataProfile.discord = apiProfile.discord
                            coreDataProfile.avatarUrl = apiProfile.avatarUrl
                            coreDataProfile.teamStatus = apiProfile.teamStatus
                            coreDataProfile.interests = apiProfile.interests.joined(separator: ",")
                            coreDataProfile.favorite = false
                        }

                        // 5) Save changes, call completion handler, unlock refresh
                        try context.save()
                        completion?()
                        isRefreshing = false
                    } catch {
                        completion?()
                        isRefreshing = false
                        os_log(
                            "Error getting saving profiles to CoreData: %s",
                            log: Logger.ui,
                            type: .error,
                            String(describing: error)
                        )
                    }
                }

                if !HIApplicationStateController.shared.isGuest {
                    HIAPI.ProfileService.getAllFavorites()
                    .onCompletion { result in
                        do {
                            let (containedFavorites, _) = try result.get()
                            HICoreDataController.shared.performBackgroundTask { context -> Void in
                                do {
                                    // 1) Unwrap contained data
                                    let apiProfiles = containedProfiles.profiles
                                    let apiFavorites = containedFavorites.profiles // Unwraps favorites based on strings (should change name to favorites)

                                    // 2) Get all CoreData Profiles.
                                    let profileFetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
                                    let coreDataProfiles = try context.fetch(profileFetchRequest)

                                    // 3) Diff the CoreData profiles and API profiles.
                                    let (
                                        coreDataProfilesToDelete,
                                        coreDataProfilesToUpdate,
                                        apiProfilesToInsert
                                    ) = diff(initial: coreDataProfiles, final: apiProfiles)

                                    // 4) Apply the diff
                                    coreDataProfilesToDelete.forEach { coreDataProfile in
                                        // Delete CoreData profile.
                                        context.delete(coreDataProfile)
                                    }

                                    coreDataProfilesToUpdate.forEach { (coreDataProfile, _) in
                                        // Update CoreData profile.
                                        coreDataProfile.favorite = apiFavorites.contains(coreDataProfile.id) //Favorites sorted by id
                                    }

                                    apiProfilesToInsert.forEach { apiProfile in
                                        // Create CoreData profile.
                                        let coreDataProfile = Profile(context: context)
                                        coreDataProfile.id = apiProfile.id
                                        coreDataProfile.firstName = apiProfile.firstName
                                        coreDataProfile.lastName = apiProfile.lastName
                                        coreDataProfile.points = Int32(apiProfile.points)
                                        coreDataProfile.timezone = apiProfile.timezone
                                        coreDataProfile.info = apiProfile.info
                                        coreDataProfile.discord = apiProfile.discord
                                        coreDataProfile.avatarUrl = apiProfile.avatarUrl
                                        coreDataProfile.teamStatus = apiProfile.teamStatus
                                        coreDataProfile.interests = apiProfile.interests.joined(separator: ",")
                                        coreDataProfile.favorite = apiFavorites.contains(coreDataProfile.id)
                                    }

                                    // 5) Save changes, call completion handler, unlock refresh
                                    try context.save()
                                    completion?()
                                    isRefreshing = false
                                } catch {
                                    completion?()
                                    isRefreshing = false
                                    os_log(
                                        "Error getting saving profiles to CoreData: %s",
                                        log: Logger.ui,
                                        type: .error,
                                        String(describing: error)
                                    )
                                }
                            }
                        } catch {
                            completion?()
                            isRefreshing = false
                            os_log(
                                "Error getting profile favorites: %s",
                                log: Logger.ui,
                                type: .error,
                                String(describing: error)
                            )
                        }
                    }
                    .authorize(with: HIApplicationStateController.shared.user)
                    .launch()
                }
            } catch {
                os_log(
                    "Error getting profiles: %s",
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
    } */

    static func refresh(completion: (() -> Void)? = nil) {
        guard !isRefreshing else {
            completion?()
            return
        }
        isRefreshing = true

        HIAPI.ProfileService.getLeaderboard()
        .onCompletion { result in
            do {
                let (containedProfiles, _) = try result.get()
                HICoreDataController.shared.performBackgroundTask { context -> Void in
                    do {
                        // 1) Unwrap contained data
                        let apiProfiles = containedProfiles.leaderboardProfiles
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
                            let coreDataProfile = Profile(context: context)
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
                        completion?()
                        isRefreshing = false
                        print(error)
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
