//
//  Location+CoreDataClass.swift
//  Reminders
//
//  Created by Kyrill Cousson on 01/02/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject {
    
    func titleString() -> String {
        return String(format: "%@ - %.0fm radius", (self.name ?? ""), self.radius)
    }
    
    func remindersCountString() -> String {
        let count = self.reminders?.count
        let reminderString = count! < 2 ? "reminder" : "reminders"
        return "\(count ?? 0) \(reminderString)"
    }
}
