//
//  Location+CoreDataClassTests.swift
//  RemindersTests
//
//  Created by Kyrill Cousson on 08/03/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import XCTest
import CoreData

class LocationTests: CoreDataTestBase {

    var locationEntity: NSEntityDescription!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        locationEntity = NSEntityDescription.entity(forEntityName: "Location", in: managedObjectContext!)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLocationCreation() {
        let location = Location(entity: locationEntity, insertInto: managedObjectContext!)
        XCTAssertNotNil(location, "Unable to create a location")
        var anError: Error? = nil
        do {
            try managedObjectContext?.save()
        } catch{
            anError = error
        }
        
        XCTAssertNil(anError, "Failed to save the context with error \(String(describing: anError)), \(String(describing: anError?._userInfo))")
    }

    func testTitleString(){
        let location = Location(entity: locationEntity, insertInto: managedObjectContext!)
        location.id = UUID.init()
        location.name = "New York"
        location.radius = 200
        XCTAssertEqual(location.titleString(), "New York - 200m radius")
    }
    
    func testRemindersCountString(){
        let location = Location(entity: locationEntity, insertInto: managedObjectContext!)

        let reminderEntity = NSEntityDescription.entity(forEntityName: "Reminder", in: managedObjectContext!)

        XCTAssertEqual(location.remindersCountString(), "0 reminder")

        let reminderA = Reminder(entity: reminderEntity!, insertInto: managedObjectContext!)
        reminderA.location = location
        XCTAssertEqual(location.remindersCountString(), "1 reminder")
        
        let reminderB = Reminder(entity: reminderEntity!, insertInto: managedObjectContext!)
        reminderB.location = location
        XCTAssertEqual(location.remindersCountString(), "2 reminders")
    }

}
