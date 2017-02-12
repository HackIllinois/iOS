//
//  Feed+CoreDataProperties.swift
//  hackillinois-2017-ios
//
//  Created by Minhyuk Park on 11/02/2017.
//  Copyright © 2017 Shotaro Ikeda. All rights reserved.
//

import Foundation
import CoreData


extension Feed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
        return NSFetchRequest<Feed>(entityName: "Feed");
    }

    @NSManaged var endTime: Date?
    @NSManaged var startTime: Date?
    @NSManaged var updated_: Date?
    @NSManaged var description_: String?
    @NSManaged var qrCode: NSNumber?
    @NSManaged var shortName: String?
    @NSManaged var name: String?
    @NSManaged var id: NSNumber?
    @NSManaged var locations: NSOrderedSet?
    @NSManaged var tags: NSSet?

}
