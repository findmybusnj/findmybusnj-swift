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
  var tableViewBackgroundView: UILabel? {
    return cardTableViewControllerUnderTest.tableView.backgroundView as? UILabel
  }
  var numberOfSections: Int {
    return cardTableViewControllerUnderTest.tableView.numberOfSections
  }
  
  override func setUp() {
    super.setUp()
    
    cardTableViewControllerUnderTest = CardTableViewController()
    
    // Initialize view
    XCTAssertNotNil(cardTableViewControllerUnderTest.view)
    cardTableViewControllerUnderTest.loadView()
    cardTableViewControllerUnderTest.viewDidLoad()
    
    // Initialize the tableview sections
    let tableView = cardTableViewControllerUnderTest.tableView
    assertTableIsEmpty()
    XCTAssertNotNil(tableView.backgroundView, "Background view should not be nil if empty list")
    XCTAssertTrue(tableView.backgroundView is UILabel, "tableView.background should contain a UILabel")
    
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
    cardTableViewControllerUnderTest.numberOfSectionsInTableView(cardTableViewControllerUnderTest.tableView)
  }
  
  // Mark: Properties
  /**
  Test property `noPrediction` is false on initialization.
  */
  func testNoPredictionInitializesToFalse() {
    let prediction = cardTableViewControllerUnderTest.noPrediction
    XCTAssertFalse(prediction, "No prediction should be false after initialization. Value was \(prediction)")
  }
  
  /**
   Test propert `items` is an empty array on initialization.
   */
  func testJsonArrayIsEmptyOnInitilialize() {
    let itemsIsEmpty = cardTableViewControllerUnderTest.items.isEmpty
    XCTAssertTrue(itemsIsEmpty, " Items array should be empty. Value was \(itemsIsEmpty)")
  }
  
  
  // MARK: UITableView - Properties
  /**
   Assert that the `attributedText` on `refreshController` for the `tableView` is set correctly
   */
  func testRefreshControllerAttributedText() {
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
  func testSeparatorColorIsClear() {
    let color =  cardTableViewControllerUnderTest.tableView.separatorColor
    XCTAssert(color == UIColor.clearColor(), "Color was not clear. Value was \(color)")
  }
  
  /**
   Asserts the `separatorStyle` is set to `.None`
   */
  func testSeparatorStyleIsNone() {
    let style = cardTableViewControllerUnderTest.tableView.separatorStyle
    XCTAssert(style == .None, "Style is not .None. Value was \(style)")
  }
  
  /**
   Asserts the initial offset y is `0-top`, which should be a negative value
   */
  func testInitialTableViewOffsetYIsNegative() {
    let offset = cardTableViewControllerUnderTest.tableView.contentOffset
    let offsetPoint = CGPointMake(0, 0)
    XCTAssertTrue(offset.y <= offsetPoint.y, "Offset is incorrectly set. Incorrect offset can cause refreshController's attributed title to show in empty list. The y coordinate should be negative. The value of the offset point was: (x: \(offset.x), y: \(offset.y))")
  }
  
  
  // UITableView - Empty Tables
  /**
   Asserts that the `numberOfSections` in the `tableView` is 0 when there is no data
   */
  func testNumberOfSectionsInEmptyTable() {
    XCTAssertTrue(cardTableViewControllerUnderTest.items.isEmpty, "Items should not be empty when testing if numberOfSections is 0 for empty table")
    XCTAssertTrue(numberOfSections == 0, "The number of sections should be 0 on an empty item set. The value was: \(numberOfSections)")
  }
  
  /**
   Asserts the message in the empty table displays "Please tap on \"Find\" to get started"
   */
  func testEmptyTableDisplaysProperMessageText() {
    assertTableIsEmpty()
    
    let message = "Please tap on \"Find\" to get started"
    XCTAssertNotNil(tableViewBackgroundView, "tableViewBackgroundView should not be nil")
    XCTAssertTrue(tableViewBackgroundView!.text == message, "background.text didn't match intended message. The actual text was: \(tableViewBackgroundView!.text)")
  }
  
  /**
   Asserts that the backgroundView is visible on an empty list
   */
  func testEmptyTableDisplaysMessageView() {
    assertTableIsEmpty()
    
    XCTAssertNotNil(tableViewBackgroundView, "tableViewBackgroundView should not be nil")
    XCTAssertTrue(tableViewBackgroundView!.hidden == false, "Background view should not be hidden")
  }
  
  /**
   Asserts that an empty `JSON` array will set `noPrediction` to true
   */
  func testUpdateTableForEmptyJSONOrNoArrivals() {
    assertTableIsEmpty()
    
    let emptyJSON: JSON = []
    cardTableViewControllerUnderTest.updateTable(emptyJSON)
    XCTAssertTrue(cardTableViewControllerUnderTest.noPrediction, "noPrediction should be set to true. Actual value was: \(cardTableViewControllerUnderTest.noPrediction)")
    
    cardTableViewControllerUnderTest.noPrediction = false
    
    let noArrivals: JSON = "No arrival times"
    cardTableViewControllerUnderTest.updateTable(noArrivals)
    XCTAssertTrue(cardTableViewControllerUnderTest.noPrediction, "noPrediction should be set to true. Actual value was: \(cardTableViewControllerUnderTest.noPrediction)")
  }
  
  
  // MARK: UITableView - One Item in Tables
  /**
   Asserts that `noPrediction` is false upon having more than one json item or an emtpy array. Also asserts that the json assigned to the view controller is the same as the on being passed to the update function.
   */
  func testUpdateTableForOneJSONObject() {
    let json = loadJSONFromFile("singleStop")
    XCTAssertTrue(!json.isEmpty, "JSON is empty when it should be greater than zero")
    
    cardTableViewControllerUnderTest.updateTable(json)
    
    XCTAssertFalse(cardTableViewControllerUnderTest.noPrediction, "noPrediction should be set to false if there is one item and it isn't \"No arrival times\" ")
    XCTAssertTrue(cardTableViewControllerUnderTest.items == json, "JSON results should match. Actual data was \(cardTableViewControllerUnderTest.items)")
  }
  
  /**
   Asserts the number of sections in the table is one when the `json` array is greater than 0 items
   */
  func testNumberOfSectionsGreaterThanOneForNoneEmptyItems() {
    let json = loadJSONFromFile("singleStop")
    XCTAssertTrue(!json.isEmpty, "JSON is empty when it should be greater than zero")
    
    cardTableViewControllerUnderTest.updateTable(json)
    cardTableViewControllerUnderTest.numberOfSectionsInTableView(cardTableViewControllerUnderTest.tableView)
    
    XCTAssertTrue(numberOfSections == 1, "Number of sections is not 1 when it should be. Actual result was \(numberOfSections)")
  }
  
  func testBackgroundViewIsNilForNonEmptyItems() {
    let json = loadJSONFromFile("singleStop")
    XCTAssertTrue(!json.isEmpty, "JSON is empty when it should be greater than zero")
    
    cardTableViewControllerUnderTest.updateTable(json)
    cardTableViewControllerUnderTest.numberOfSectionsInTableView(cardTableViewControllerUnderTest.tableView)
    
    XCTAssertNil(tableViewBackgroundView, "Table view backgroundView should be nil when there are items backing the table. The actual value was \(tableViewBackgroundView)")
  }
}
