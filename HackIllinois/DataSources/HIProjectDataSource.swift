//
//  HIProjectDataSource.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 12/25/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import CoreData
import HIAPI
import os

final class HIProjectDataSource {

    // Serializes access to isRefreshing.
    private static let isRefreshineQueue = DispatchQueue(label: "org.hackillinois.org.hi_project_data_source.is_refreshing_queue", attributes: .concurrent)
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

        HIAPI.ProjectService.getAllProjects()
        .onCompletion { result in
            do {
                let (containedProjects, _) = try result.get()
                HICoreDataController.shared.performBackgroundTask { context -> Void in
                    do {
                        // 1) Unwrap contained data
                        let apiProjects = containedProjects.projects

                        // 2) Get all CoreData Projects.
                        let projectFetchRequest = NSFetchRequest<Project>(entityName: "Project")
                        let coreDataProjects = try context.fetch(projectFetchRequest)

                        // 3) Diff the CoreData projects and API projects.
                        let (
                            coreDataProjectsToDelete,
                            coreDataProjectsToUpdate,
                            apiProjectsToInsert
                        ) = diff(initial: coreDataProjects, final: apiProjects)

                        // 4) Apply the diff
                        coreDataProjectsToDelete.forEach { coreDataProject in
                            // Delete CoreData project.
                            context.delete(coreDataProject)
                        }

                        coreDataProjectsToUpdate.forEach { (coreDataProject, apiProject) in
                            // Update CoreData project.
                            coreDataProject.id = apiProject.id
                            coreDataProject.name = apiProject.name
                            coreDataProject.info = apiProject.info
                            coreDataProject.mentors = apiProject.mentors.joined(separator: ",")
                            coreDataProject.room = apiProject.room
                            coreDataProject.tags = apiProject.tags.sorted().joined(separator: ",")
                            coreDataProject.number = apiProject.number
                            coreDataProject.favorite = false
                        }

                        apiProjectsToInsert.forEach { apiProject in
                            // Create CoreData project.
                            let coreDataProject = Project(context: context)
                            coreDataProject.id = apiProject.id
                            coreDataProject.name = apiProject.name
                            coreDataProject.info = apiProject.info
                            coreDataProject.mentors = apiProject.mentors.joined(separator: ",")
                            coreDataProject.room = apiProject.room
                            coreDataProject.tags = apiProject.tags.sorted().joined(separator: ",")
                            coreDataProject.number = apiProject.number
                            coreDataProject.favorite = false
                        }

                        // 5) Save changes, call completion handler, unlock refresh
                        try context.save()
                        completion?()
                        isRefreshing = false
                    } catch {
                        completion?()
                        isRefreshing = false
                        os_log(
                            "Error getting saving projects to CoreData: %s",
                            log: Logger.ui,
                            type: .error,
                            String(describing: error)
                        )
                    }
                }

                if !HIApplicationStateController.shared.isGuest {
                    HIAPI.ProjectService.getAllFavorites()
                    .onCompletion { result in
                        do {
                            let (containedFavorites, _) = try result.get()
                            HICoreDataController.shared.performBackgroundTask { context -> Void in
                                do {
                                    // 1) Unwrap contained data
                                    let apiProjects = containedProjects.projects
                                    let apiFavorites = containedFavorites.projects // Unwraps favorites based on strings (should change name to favorites)

                                    // 2) Get all CoreData Projects.
                                    let projectFetchRequest = NSFetchRequest<Project>(entityName: "Project")
                                    let coreDataProjects = try context.fetch(projectFetchRequest)

                                    // 3) Diff the CoreData projects and API projects.
                                    let (
                                        coreDataProjectsToDelete,
                                        coreDataProjectsToUpdate,
                                        apiProjectsToInsert
                                    ) = diff(initial: coreDataProjects, final: apiProjects)

                                    // 4) Apply the diff
                                    coreDataProjectsToDelete.forEach { coreDataProject in
                                        // Delete CoreData project.
                                        context.delete(coreDataProject)
                                    }

                                    coreDataProjectsToUpdate.forEach { (coreDataProject, _) in
                                        // Update CoreData project.
                                        coreDataProject.favorite = apiFavorites.contains(coreDataProject.id) //Favorites sorted by id
                                    }

                                    apiProjectsToInsert.forEach { apiProject in
                                        // Create CoreData project.
                                        let coreDataProject = Project(context: context)
                                        coreDataProject.id = apiProject.id
                                        coreDataProject.name = apiProject.name
                                        coreDataProject.info = apiProject.info
                                        coreDataProject.mentors = apiProject.mentors.joined(separator: ",")
                                        coreDataProject.room = apiProject.room
                                        coreDataProject.tags = apiProject.tags.sorted().joined(separator: ",")
                                        coreDataProject.number = apiProject.number
                                        coreDataProject.favorite = apiFavorites.contains(coreDataProject.id)
                                    }

                                    // 5) Save changes, call completion handler, unlock refresh
                                    try context.save()
                                    completion?()
                                    isRefreshing = false
                                } catch {
                                    completion?()
                                    isRefreshing = false
                                    os_log(
                                        "Error getting saving projects to CoreData: %s",
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
                                "Error getting project favorites: %s",
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
                    "Error getting projects: %s",
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
