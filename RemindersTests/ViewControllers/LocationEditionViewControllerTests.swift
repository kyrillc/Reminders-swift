//
//  LocationEditionViewControllerTests.swift
//  RemindersTests
//
//  Created by Kyrill Cousson on 13/03/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import XCTest

class LocationEditionViewControllerTests: CoreDataTestBase {

    var vc: LocationEditionViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:Bundle(for: type(of: self)))
        self.vc = storyboard.instantiateViewController(withIdentifier: "LocationEditionViewController") as? LocationEditionViewController
        self.vc.loadView()
        //self.vc = LocationEditionViewController()
        
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
        XCTAssert((vc!.location != nil), "location is nil")
    }
}
