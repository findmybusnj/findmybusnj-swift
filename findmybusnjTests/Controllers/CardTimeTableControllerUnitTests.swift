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
  
  func testRefreshControllerAttributedText() {
    XCTAssertNotNil(cardTableViewControllerUnderTest.refreshControl, "Refresh controller was nil")
    let refreshController = cardTableViewControllerUnderTest.refreshControl!
    
    XCTAssertNotNil(refreshController.attributedTitle, "Attributed title was nil")
    let attributedTitle = refreshController.attributedTitle!
    
    // Xcode adds {\n} to the string
    XCTAssertTrue(attributedTitle.description == "Pull to refresh stops{\n}", "Refresh controller attributed title set incorrectly. Value was \(attributedTitle.description)")
  }
}
