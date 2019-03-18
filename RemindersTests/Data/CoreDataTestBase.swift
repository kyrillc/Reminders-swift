//
//  CoreDataTestBase.swift
//  RemindersTests
//
//  Created by Kyrill Cousson on 13/03/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//
// https://stackoverflow.com/questions/30423004/swift-core-data-setting-relationship-unrecognized-selector-send-to-instance-in-u

import UIKit
import XCTest
import CoreData

class CoreDataTestBase: XCTestCase {
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "book.persistence.GiftReminder" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Reminders", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Reminders.sqlite")
        
        do {
            try coordinator!.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            coordinator = nil
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            print("Unresolved error \(error.localizedDescription), \(String(describing: error._userInfo))")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            if (moc.hasChanges) {
                do {
                    try moc.save()
                } catch {
                    print("Error saving context: \(error)")
                }
            }
        }
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        self.managedObjectContext = nil
        super.tearDown()
    }
    
}
