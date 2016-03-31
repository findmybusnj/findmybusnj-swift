
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
  var tableUnderTest: XCUIElement {
    return app.tables["ETABusTimeTable"]
  }
  
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
  
  func test_Assert_Save_Favorite_Exists() {
    XCTAssert(app.buttons["saveFavorite"].exists, "Save button should exist")
  }
  
  /**
   Asserts that the app has text hinting user to navigate to begin
   */
  func test_Assert_Background_Hint_Exists_On_Empty_Table() {
    XCTAssert(app.staticTexts["Please tap on \"Find\" to get started"].exists, "Background hint information is missing.")
  }
  
  func test_Assert_Find_Button_Exists() {
    XCTAssert(app.buttons["Find"].exists, "Find button should exist")
  }
  
  /**
   Tests that user is notified if trying to save when no search data is present
   */
  func test_Assert_Warning_On_Empty_Save() {
    let saveButton = app.navigationBars["findmybusnj.ETABusTimeTable"].buttons["saveFavorite"]
    let saveAlert = app.alerts["No stop to save"]
    
    XCTAssertTrue(saveButton.exists)
    saveButton.doubleTap()  // TODO - Figure out why a doubleTap() is needed over a tap()
    
    let exists = NSPredicate(format: "exists == true")
    expectationForPredicate(exists, evaluatedWithObject: saveAlert, handler: nil)
    waitForExpectationsWithTimeout(5, handler: nil)
    
    XCTAssertTrue(saveAlert.exists)
    saveAlert.collectionViews.buttons["Done"].tap()
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
