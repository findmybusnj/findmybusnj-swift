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
  
  override func setUp() {
    super.setUp()
    
    cardTableViewControllerUnderTest = CardTableViewController()
    
    // Initialize view
    XCTAssertNotNil(cardTableViewControllerUnderTest.view)
    cardTableViewControllerUnderTest.loadView()
    cardTableViewControllerUnderTest.viewDidLoad()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
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
  
  
  // MARK: UITableView
  /**
   Asser that the `attributedText` on `refreshController` for the `tableView` is set correctly
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
   Tests to make sure the initial offset y is `0-top`, which should be a negative value
   */
  func testInitialTableViewOffsetYIsNegative() {
    let offset = cardTableViewControllerUnderTest.tableView.contentOffset
    let offsetPoint = CGPointMake(0, 0)
    XCTAssertTrue(offset.y <= offsetPoint.y, "Offset is incorrectly set. Incorrect offset can cause refreshController's attributed title to show in empty list. The y coordinate should be negative. The value of the offset point was: (x: \(offset.x), y: \(offset.y))")
  }
  
  /**
   Asserts the message in the empty table displays "Please tap on \"Find\" to get started"
   */
  func testEmptyTableDisplaysMessageProperMessage() {
    let tableView = cardTableViewControllerUnderTest.tableView
    
    XCTAssertTrue(cardTableViewControllerUnderTest.items.isEmpty, "items should be empty when running this test")
    cardTableViewControllerUnderTest.numberOfSectionsInTableView(cardTableViewControllerUnderTest.tableView)
    
    XCTAssertNotNil(tableView.backgroundView, "Background view should not be nil if empty list")
    XCTAssertTrue(tableView.backgroundView is UILabel, "tableView.background should contain a UILabel")
    
    let background = tableView.backgroundView as! UILabel
    let message = "Please tap on \"Find\" to get started"
    XCTAssertTrue(background.text == message, "background.text didn't match intended message. The actual text was: \(background.text)")
    
  }
}
