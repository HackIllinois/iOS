//
//  LeaderboardProfile+CoreDataProperties.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/8/22.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import CoreData

extension LeaderboardProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LeaderboardProfile> {
        return NSFetchRequest<LeaderboardProfile>(entityName: "LeaderboardProfile")
    }

    @NSManaged public var id: String
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var points: Int32
}
