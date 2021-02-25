//
//  Profile+CoreDataProperties.swift
//  HackIllinois
//
//  Created by Jeff Kim on 2/25/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//
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
