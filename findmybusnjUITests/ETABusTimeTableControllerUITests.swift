
//
//  findmybusnjUITests.swift
//  findmybusnjUITests
//
//  Created by David Aghassi on 9/28/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import XCTest

class ETABusTimeTableControllerUITests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  /**
   Checks that reload will not crash when there is no data
   */
  func testEmptyListRefreshes() {
    let app = XCUIApplication()
    app.tabBars.buttons["Times"].tap()
    
    let table = app.navigationBars["findmybusnj.ETABusTimeTable"]
    XCTAssertTrue(table.tableRows.count == 0)
    
    let start = table.coordinateWithNormalizedOffset(CGVectorMake(10, 10))
    let end = table.coordinateWithNormalizedOffset(CGVectorMake(10, 16))
    
    start.pressForDuration(0, thenDragToCoordinate: end)
    XCTAssertTrue(table.tableRows.count == 0)
  }
}
