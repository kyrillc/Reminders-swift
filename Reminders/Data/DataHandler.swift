//
//  DataHandler.swift
//  Reminders
//
//  Created by Kyrill Cousson on 06/02/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataHandler {
    
    static func saveData(onContext context: NSManagedObjectContext!){
        do {
            try context!.save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func deleteObject(_ object: NSManagedObject, onContext context: NSManagedObjectContext!, andCommit: Bool){
        context.delete(object)
        if (andCommit){
            saveData(onContext: context)
        }
    }
    
    static func discardChanges(onContext context: NSManagedObjectContext!){
        context!.rollback()
    }
    
    static func allReminders() -> [Reminder] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let remindersFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reminder")
        do {
            let reminders = try context.fetch(remindersFetchRequest) as! [Reminder]
            return reminders
        } catch {
            print("error at context.execute")
            return []
        }
    }
    
    
}


