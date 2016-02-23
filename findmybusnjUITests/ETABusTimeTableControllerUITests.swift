
//
//  findmybusnjUITests.swift
//  findmybusnjUITests
//
//  Created by David Aghassi on 9/28/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import XCTest

class ETABusTimeTableControllerUITests: XCTestCase {
  let app = XCUIApplication()
  
  override func setUp() {
    super.setUp()
    
    continueAfterFailure = false
    app.launch()
    XCTAssertTrue(app.tables["ETABusTimeTable"].tableRows.count == 0, "Table should initialize with with no rows")
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testAssertSaveFavoriteExists() {
    XCTAssert(app.buttons["saveFavorite"].exists, "Save button should exist")
  }
  
  func testAssertFindButtonExists() {
    XCTAssert(app.buttons["Find"].exists, "Find button should exist")
  }
    
  /**
   Checks that reload will not crash when there is no data
   */
  func testEmptyListRefreshes() {
    app.tabBars.buttons["Times"].tap()
    
    let table = app.navigationBars["findmybusnj.ETABusTimeTable"]
    XCTAssertTrue(table.tableRows.count == 0)
    
    let start = table.coordinateWithNormalizedOffset(CGVectorMake(10, 10))
    let end = table.coordinateWithNormalizedOffset(CGVectorMake(10, 16))
    
    start.pressForDuration(0, thenDragToCoordinate: end)
    XCTAssertTrue(table.tableRows.count == 0)
  }
}
