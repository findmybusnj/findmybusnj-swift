//
//  CardTimeTableControllerUnitTests.swift
//  findmybusnj
//
//  Created by David Aghassi on 2/24/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import findmybusnj

/**
 Class focused on testing CardTableViewController in a unit test format
 */
class CardTimeTableControllerUnitTests: XCTestCase {
  var cardTableViewControllerUnderTest: CardTableViewController!
  
  // MARK: Table View Property Variables
  var tableViewBackgroundView: UILabel? {
    return cardTableViewControllerUnderTest.tableView.backgroundView as? UILabel
  }
  var numberOfSections: Int {
    return cardTableViewControllerUnderTest.tableView.numberOfSections
  }
  var numberOfRows: Int {
    return cardTableViewControllerUnderTest.tableView.numberOfRows(inSection: 0)
  }
  
  // MARK: Setup and Teardown
  override func setUp() {
    super.setUp()
    
    cardTableViewControllerUnderTest = CardTableViewController()
    
    // Initialize view
    XCTAssertNotNil(cardTableViewControllerUnderTest.view)
    
    
    // Initialize the tableview sections
    if let tableView = cardTableViewControllerUnderTest.tableView {
      assertTableIsEmpty()
      XCTAssertGreaterThan(numberOfRows, -1, "Number of rows should never be less than 0. This method is used to initialize backgroundView for future tests.")  // By doing this, we cause the backgroundView to be initialized
      XCTAssertNotNil(tableView.backgroundView, "Background view should not be nil if empty list")
      XCTAssertTrue(tableView.backgroundView is UILabel, "tableView.background should contain a UILabel")
    }
    else {
      XCTFail()
    }
    
    
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  // MARK: Helper Functions
  /**
   Asserts the table is empty and calls numberOfSectionsInTableView
   */
  func assertTableIsEmpty() {
    XCTAssertTrue(cardTableViewControllerUnderTest.items.isEmpty, "items should be empty when running this test")
  }
  
  // Mark: Properties
  /**
  Test property `noPrediction` is false on initialization.
  */
  func test_NoPrediction_InitializesToFalse() {
    let prediction = cardTableViewControllerUnderTest.noPrediction
    XCTAssertFalse(prediction, "No prediction should be false after initialization. Value was \(prediction)")
  }
  
  /**
   Test propert `items` is an empty array on initialization.
   */
  func test_JsonArray_IsEmpty_OnInitilialize() {
    let itemsIsEmpty = cardTableViewControllerUnderTest.items.isEmpty
    XCTAssertTrue(itemsIsEmpty, " Items array should be empty. Value was \(itemsIsEmpty)")
  }
  
  
  // MARK: UITableView - Properties
  /**
   Assert that the `attributedText` on `refreshController` for the `tableView` is set correctly
   */
  func test_RefreshController_AttributedText() {
    XCTAssertNotNil(cardTableViewControllerUnderTest.refreshControl, "Refresh controller was nil")
    let refreshController = cardTableViewControllerUnderTest.refreshControl!
    
    XCTAssertNotNil(refreshController.attributedTitle, "Attributed title was nil")
    let attributedTitle = refreshController.attributedTitle!
    
    // Xcode adds {\n} to the string
    XCTAssertTrue(attributedTitle.description == "Pull to refresh stops{\n}", "Refresh controller attributed title set incorrectly. Value was \(attributedTitle.description)")
  }
  
  /**
   Asserts the `tableView` property `separatorColor` is set as `UIColor.clearColor()`
   */
  func test_SeparatorColor_IsClear() {
    let color =  cardTableViewControllerUnderTest.tableView.separatorColor
    XCTAssert(color == UIColor.clear, "Color was not clear. Value was \(color)")
  }
  
  /**
   Asserts the `separatorStyle` is set to `.None`
   */
  func test_SeparatorStyle_IsNone() {
    let style = cardTableViewControllerUnderTest.tableView.separatorStyle
    XCTAssert(style == .none, "Style is not .None. Value was \(style)")
  }
  
  /**
   Asserts the initial offset y is `0-top`, which should be a negative value
   */
  func test_InitialTableView_OffsetY_IsNegative() {
    let offset = cardTableViewControllerUnderTest.tableView.contentOffset
    let offsetPoint = CGPoint(x: 0, y: 0)
    XCTAssertTrue(offset.y <= offsetPoint.y, "Offset is incorrectly set. Incorrect offset can cause refreshController's attributed title to show in empty list. The y coordinate should be negative. The value of the offset point was: (x: \(offset.x), y: \(offset.y))")
  }
  
  
  // UITableView - Empty Tables
  /**
   Asserts that the `numberOfSections` in the `tableView` is 0 when there is no data
   */
  func test_NumberOfSections_IsZero_OnEmptyTable() {
    XCTAssertTrue(cardTableViewControllerUnderTest.items.isEmpty, "Items should not be empty when testing if numberOfSections is 0 for empty table")
    XCTAssertTrue(numberOfSections == 0, "The number of sections should be 0 on an empty item set. The value was: \(numberOfSections)")
  }
  
  /**
   Asserts the message in the empty table displays "Please tap on \"Find\" to get started"
   */
  func test_EmptyTable_DisplaysProperMessageText() {
    assertTableIsEmpty()
    
    let message = "Please tap on \"Find\" to get started"
    XCTAssertNotNil(tableViewBackgroundView, "tableViewBackgroundView should not be nil")
    XCTAssertTrue(tableViewBackgroundView!.text == message, "background.text didn't match intended message. The actual text was: \(tableViewBackgroundView!.text)")
  }
  
  /**
   Asserts that the backgroundView is visible on an empty list
   */
  func test_EmptyTable_DisplaysMessageView() {
    assertTableIsEmpty()
    
    XCTAssertNotNil(tableViewBackgroundView, "tableViewBackgroundView should not be nil")
    XCTAssertFalse(tableViewBackgroundView!.isHidden, "Background view should not be hidden")
  }
  
  /**
   Asserts that an empty `JSON` array will set `noPrediction` to true
   */
  func test_UpdateTable_ForEmptyJSON() {
    assertTableIsEmpty()
    
    let emptyJSON: JSON = []
    cardTableViewControllerUnderTest.updateTable(emptyJSON)
    XCTAssertTrue(cardTableViewControllerUnderTest.noPrediction, "noPrediction should be set to true. Actual value was: \(cardTableViewControllerUnderTest.noPrediction)")
  }
  
  
  // MARK: UITableView - One Item in Tables
  /**
   Asserts noPrediction is set to `true` when there is no prediction
   */
  func test_UpdateTable_ForNoPrediction() {
    let noArrivals: JSON = "No arrival times"
    cardTableViewControllerUnderTest.updateTable(noArrivals)
    XCTAssertTrue(cardTableViewControllerUnderTest.noPrediction, "noPrediction should be set to true. Actual value was: \(cardTableViewControllerUnderTest.noPrediction)")
  }
  
  /**
   Asserts that `noPrediction` is false upon having more than one json item or an emtpy array. Also asserts that the json assigned to the view controller is the same as the on being passed to the update function.
   */
  func test_UpdateTable_For_OneJSONObject() {
    let json = loadJSONFromFile(JSONFileName.singleStop.rawValue)
    
    cardTableViewControllerUnderTest.updateTable(json)
    
    XCTAssertFalse(cardTableViewControllerUnderTest.noPrediction, "noPrediction should be set to false if there is one item and it isn't \"No arrival times\" ")
    XCTAssertTrue(cardTableViewControllerUnderTest.items == json, "JSON results should match. Actual data was \(cardTableViewControllerUnderTest.items)")
  }
  
  /**
   Asserts the number of sections in the table is one when the `json` array is greater than 0 items
   */
  func test_NumberOfSections_GreaterThan_One_For_NoneEmptyItems() {
    let json = loadJSONFromFile(JSONFileName.singleStop.rawValue)
    
    cardTableViewControllerUnderTest.updateTable(json)
    
    XCTAssertTrue(numberOfSections == 1, "Number of sections is not 1 when it should be. Actual result was \(numberOfSections)")
  }
  
  /**
   Assert the number of sections in the table is one when `noPrediction` is true
   */
  func test_NumberOfSections_IsZero_ForNoPrediction() {
    let json = loadJSONFromFile("noPrediction")
    
    cardTableViewControllerUnderTest.updateTable(json)
    XCTAssertTrue(cardTableViewControllerUnderTest.noPrediction, "No predictions should be set to true after passing in a no prediction string")
    
    XCTAssertTrue(numberOfSections == 1, "There should only be one section after noPrediction is set to true. The value was: \(numberOfSections)")
  }
  
  /**
   Asserts the number of rows in the table is one when `noPrediction` is true
   */
  func test_NumberOfRowsInSection_IsZero_ForNoPrediction() {
    let json = loadJSONFromFile("noPrediction")
    
    cardTableViewControllerUnderTest.updateTable(json)
    XCTAssertTrue(cardTableViewControllerUnderTest.noPrediction, "No predictions should be set to true after passing in a no prediction string")
    
    XCTAssertTrue(numberOfRows == 1, "There should only be one row item when there is no prediction")
  }
  
  /**
   Assert that `backgroundView` on the `tableView` is nil when there is results
   */
  func test_BackgroundView_IsNil_For_NonEmptyItems() {
    let json = loadJSONFromFile(JSONFileName.singleStop.rawValue)
    
    if (cardTableViewControllerUnderTest.tableView) != nil {
      cardTableViewControllerUnderTest.updateTable(json)
      
      XCTAssertNil(tableViewBackgroundView, "Table view backgroundView should be nil when there are items backing the table. The actual value was \(tableViewBackgroundView)")
    }
    else {
      XCTFail()
    }
  }
  
  /**
   Asserts number of rows in table equals the length of the json array backing the table
   */
  func test_NumberOfRows_Equals_Json_Length() {
    let json = loadJSONFromFile(JSONFileName.singleStop.rawValue)
    
    cardTableViewControllerUnderTest.updateTable(json)
    XCTAssertTrue(numberOfSections == 1, "Number of sections is not one when it should be. The actual value was: \(numberOfSections)")
    
    XCTAssertTrue(numberOfRows == json.count, "Number of rows did not equal the size of the json array. The value for the row was: \(numberOfRows) \n The count of the json array was: \(json.count)")
  }
}
