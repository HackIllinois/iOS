//
//  Announcement+CoreDataProperties.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/25/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import CoreData

extension Announcement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Announcement> {
        return NSFetchRequest<Announcement>(entityName: "Announcement")
    }

    @NSManaged public var topic: String
    @NSManaged public var body: String
    @NSManaged public var time: Date
    @NSManaged public var title: String

}
