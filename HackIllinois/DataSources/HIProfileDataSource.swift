//
//  HIProfileDataSource.swift
//  HackIllinois
//
//  Created by Jeff Kim on 2/25/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//

import Foundation
import CoreData
import HIAPI
import os

final class HIProfileDataSource {

    // Serializes access to isRefreshing.
    private static let isRefreshineQueue = DispatchQueue(label: "org.hackillinois.org.hi_profile_data_source.is_refreshing_queue", attributes: .concurrent)
    // Tracks if the DataSource is refreshing.
    private static var _isRefreshing = false
    // Setter and getter for isRefreshing.
    public static var isRefreshing: Bool {
        get { return isRefreshineQueue.sync { _isRefreshing } }
        set { isRefreshineQueue.sync(flags: .barrier) { _isRefreshing = newValue } }
    }

    // Waive swiftlint warning
    // swiftlint:disable:next function_body_length
    static func refresh(teamStatus: String, interests: [String], completion: (() -> Void)? = nil) {
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

                        // 2) Get all CoreData Projects.
                        let profileFetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
                        let coreDataProfiles = try context.fetch(profileFetchRequest)

                        // 3) Diff the CoreData projects and API projects.
                        let (
                            coreDataProfilesToDelete,
                            coreDataProfilesToUpdate,
                            apiProfilesToInsert
                        ) = diff(initial: coreDataProfiles, final: apiProfiles)

                        // 4) Apply the diff
                        coreDataProfilesToDelete.forEach { coreDataProfile in
                            // Delete CoreData project.
                            context.delete(coreDataProfile)
                        }

                        coreDataProfilesToUpdate.forEach { (coreDataProfile, apiProfile) in
                            // Update CoreData project.
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
                        }

                        apiProfilesToInsert.forEach { apiProfile in
                            // Create CoreData project.
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
    }
}
