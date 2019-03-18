//
//  Reminder+CoreDataClassTests.swift
//  RemindersTests
//
//  Created by Kyrill Cousson on 13/03/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import XCTest
import CoreData

class ReminderTests: CoreDataTestBase {

    var reminderEntity : NSEntityDescription!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        reminderEntity = NSEntityDescription.entity(forEntityName: "Reminder", in: managedObjectContext!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    /*
     Test we can create a reminder
     */
    func testReminderCreation() {
        let reminder = Reminder(entity: reminderEntity, insertInto: managedObjectContext!)
        XCTAssertNotNil(reminder, "Unable to create a reminder")
        var anError: Error? = nil
        do {
            try managedObjectContext?.save()
        } catch{
            anError = error
        }
        
        XCTAssertNil(anError, "Failed to save the context with error \(String(describing: anError)), \(String(describing: anError?._userInfo))")
    }

}
