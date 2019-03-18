//
//  SettingsViewControllerTests.swift
//  RemindersTests
//
//  Created by Kyrill Cousson on 18/03/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import XCTest

class SettingsViewControllerTests: XCTestCase {

    var vc: SettingsViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:Bundle(for: type(of: self)))
        self.vc = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
        self.vc.loadView()
        
        if (self.vc == nil){
            print("self.vc == nil")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewDidLoad(){
        vc.viewDidLoad()
        XCTAssert((vc!.rows.count >= 1), "rows array has an unexpected count")
    }
}
