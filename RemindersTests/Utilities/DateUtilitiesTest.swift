//
//  RemindersTests.swift
//  RemindersTests
//
//  Created by Kyrill Cousson on 28/01/2019.
//  Copyright © 2019 Kyrill Cousson. All rights reserved.
//

import XCTest
@testable import Reminders

class UtilitiesTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testCeil(){
        let userCalendar = Calendar.current
        let testDateComp = DateComponents(calendar: nil,
                                          timeZone: nil,
                                          era: nil,
                                          year: 2018,
                                          month: 12,
                                          day: 31,
                                          hour: 23,
                                          minute: 56,
                                          second: 0,
                                          nanosecond: nil,
                                          weekday: nil,
                                          weekdayOrdinal: nil,
                                          quarter: nil,
                                          weekOfMonth: nil,
                                          weekOfYear: nil,
                                          yearForWeekOfYear: nil)
        let testDate = userCalendar.date(from: testDateComp)!
        let testDatePlus5 = testDate.ceil(precision: 5*60)
        
        let expectedDateComp = DateComponents(calendar: nil,
                                              timeZone: nil,
                                              era: nil,
                                              year: 2019,
                                              month: 1,
                                              day: 1,
                                              hour: 0,
                                              minute: 0,
                                              second: 0,
                                              nanosecond: nil,
                                              weekday: nil,
                                              weekdayOrdinal: nil,
                                              quarter: nil,
                                              weekOfMonth: nil,
                                              weekOfYear: nil,
                                              yearForWeekOfYear: nil)
        let expectedDate = userCalendar.date(from: expectedDateComp)!
        XCTAssertEqual(testDatePlus5.timeIntervalSinceNow, expectedDate.timeIntervalSinceNow, accuracy: 1, "\(testDate) rounded to 5 minutes should be equal to \(expectedDate)")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
