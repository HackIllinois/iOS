//
//  Profile+CoreDataProperties.swift
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

extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var id: String
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var points: Int32
    @NSManaged public var timezone: String
    @NSManaged public var info: String
    @NSManaged public var discord: String
    @NSManaged public var avatarUrl: String
    @NSManaged public var teamStatus: String
    @NSManaged public var interests: String

}
