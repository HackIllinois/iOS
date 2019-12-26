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
                HIAPI.ProjectService.getAllFavorites()
                .onCompletion { result in
                    do {
                        let (containedFavorites, _) = try result.get()
                        HICoreDataController.shared.performBackgroundTask { context -> Void in
                            do {
                                // 1) Unwrap contained data
                                let apiProjects = containedProjects.projects
                                let apiFavorites = containedFavorites.events // Unwraps favorites based on strings (should change name to favorites)

                                // 2) Compute all the unique API locations.
                                let allLocations = apiProjects.compactMap { $0.location }
                                var uniquinglocationDictionary = [String: HIAPI.Location]()
                                allLocations.forEach {
                                    uniquinglocationDictionary[$0.name] = $0
                                }
                                let uniqueLocations = Array(uniquinglocationDictionary.values)

                                // 3) Get all CoreData locations.
                                let locationFetchRequest = NSFetchRequest<Location>(entityName: "Location")
                                let coreDataLocations = try context.fetch(locationFetchRequest)

                                // 4) Diff the CoreData locations and API locations.
                                let (coreDataLocationsToDelete, coreDataLocationsToUpdate, apiLocationsToInsert)
                                    = diff(initial: coreDataLocations, final: uniqueLocations)

                                // 5) Create dictionary mapping location names to CoreData locations.
                                var coreDataLocationsDicionary = [String: Location]()

                                // 6) Apply location diff to CoreData.
                                coreDataLocationsToDelete.forEach { coreDataLocation in
                                    // Delete CoreData location.
                                    context.delete(coreDataLocation)
                                }

                                coreDataLocationsToUpdate.forEach { (coreDataLocation, apiLocation) in
                                    // Update CoreData location.
                                    coreDataLocation.latitude = apiLocation.latitude
                                    coreDataLocation.longitude = apiLocation.longitude

                                    // Add to dictionary mapping names to CoreData locations.
                                    coreDataLocationsDicionary[coreDataLocation.name] = coreDataLocation
                                }

                                apiLocationsToInsert.forEach { apiLocation in
                                    // Create CoreData location.
                                    let coreDataLocation = Location(context: context)
                                    coreDataLocation.name = apiLocation.name
                                    coreDataLocation.latitude = apiLocation.latitude
                                    coreDataLocation.longitude = apiLocation.longitude

                                    // Add to dictionary mapping names to CoreData locations.
                                    coreDataLocationsDicionary[coreDataLocation.name] = coreDataLocation
                                }

                                // 7) Get all CoreData locations.
                                let eventFetchRequest = NSFetchRequest<Project>(entityName: "Project")
                                let coreDataProjects = try context.fetch(eventFetchRequest)

                                // 8) Diff the CoreData projects and API projects.
                                let (
                                    coreDataProjectsToDelete,
                                    coreDataProjectsToUpdate,
                                    apiProjectsToInsert
                                ) = diff(initial: coreDataProjects, final: apiProjects)

                                // 9) Apply the diff
                                coreDataProjectsToDelete.forEach { coreDataProject in
                                    // Delete CoreData event.
                                    context.delete(coreDataProject)
                                }

                                coreDataProjectsToUpdate.forEach { (coreDataProject, apiProject) in
                                    // Update CoreData event.
                                    coreDataProject.id = apiProject.id
                                    coreDataProject.name = apiProject.name
                                    coreDataProject.mentors = apiProject.mentors
                                    guard let coreDataLocation = coreDataLocationsDicionary[apiProject.location.name] else { fatalError("Could not load location") }
                                    coreDataProject.location = coreDataLocation
                                    coreDataProject.favorite = apiFavorites.contains(coreDataProject.id) //Favorites sorted by id
                                }

                                apiProjectsToInsert.forEach { apiProject in
                                    // Create CoreData event.
                                    let coreDataProject = Project(context: context)
                                    coreDataProject.id = apiProject.id
                                    coreDataProject.name = apiProject.name
                                    coreDataProject.mentors = apiProject.mentors
                                    guard let coreDataLocation = coreDataLocationsDicionary[apiProject.location.name] else { fatalError("Could not load location") }
                                    coreDataProject.location = coreDataLocation
                                    coreDataProject.favorite = apiFavorites.contains(coreDataProject.id)
                                }

                                // 10) Save changes, call completion handler, unlock refresh
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
                        print(error)
                    }
                }
                .authorize(with: HIApplicationStateController.shared.user)
                .launch()
            } catch {
                completion?()
                isRefreshing = false
            }
        }
        .authorize(with: HIApplicationStateController.shared.user)
        .launch()
    }
}
