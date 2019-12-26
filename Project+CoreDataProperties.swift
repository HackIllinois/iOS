//
//  Project+CoreDataProperties.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 12/20/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import CoreData

extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var code: String
    @NSManaged public var id: String
    @NSManaged public var mentors: [String]
    @NSManaged public var name: String
    @NSManaged public var tags: [NSObject]
    @NSManaged public var location: Location
    @NSManaged public var favorite: Bool

}
