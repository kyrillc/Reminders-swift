//
//  Reminder+CoreDataProperties.swift
//  Reminders
//
//  Created by Kyrill Cousson on 01/02/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var done: Bool
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var geofenceOption: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var location: Location?

}
