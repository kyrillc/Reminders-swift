//
//  DataHandler.swift
//  Reminders
//
//  Created by Kyrill Cousson on 06/02/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import Foundation
import CoreData

func saveData(onContext context: NSManagedObjectContext!){
    do {
        try context!.save()
    } catch {
        print("Failed saving")
    }
}

func deleteObject(_ object: NSManagedObject, onContext context: NSManagedObjectContext!, andCommit: Bool){
    context.delete(object)
    if (andCommit){
        saveData(onContext: context)
    }
}

func discardChanges(onContext context: NSManagedObjectContext!){
    context!.rollback()
}
