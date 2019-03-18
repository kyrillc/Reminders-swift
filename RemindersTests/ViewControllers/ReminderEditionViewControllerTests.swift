//
//  ReminderEditionViewControllerTests.swift
//  RemindersTests
//
//  Created by Kyrill Cousson on 07/03/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import XCTest

class ReminderEditionViewControllerTests: CoreDataTestBase {
    
    var vc: ReminderEditionViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:Bundle(for: type(of: self)))
        self.vc = storyboard.instantiateViewController(withIdentifier: "ReminderEditionViewController") as? ReminderEditionViewController
        self.vc.loadView()
        
        vc.setupContext(context: managedObjectContext!)
        if (self.vc == nil){
            print("self.vc == nil")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewDidLoad(){
        vc.viewDidLoad()
        XCTAssert((vc!.reminder != nil), "reminder is nil")
        XCTAssert((vc!.sections.count == 2), "sections array has an unexpected count")
        let sectionName0 = vc!.sections[0].sectionName
        let sectionName1 = vc!.sections[1].sectionName
        var expectation = ReminderEditionViewController.Sections.FormSection.rawValue
        XCTAssert((sectionName0 == expectation),
                  "sectionName expected is wrong. Got sectionName:\(sectionName0). Expected sectionName:\(expectation)")

        expectation = ReminderEditionViewController.Sections.SaveSection.rawValue
        XCTAssert((sectionName1 == expectation),
                  "sectionName expected is wrong. Got sectionName:\(sectionName1). Expected sectionName:\(expectation)")
    }
    
}
