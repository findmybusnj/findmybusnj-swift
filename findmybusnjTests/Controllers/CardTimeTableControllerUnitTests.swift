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
  
  func testNoPredictionInitializesToFalse() {
    let prediction = cardTableViewControllerUnderTest.noPrediction
    XCTAssertFalse(prediction, "No prediction should be false after initialization. Value was \(prediction)")
  }
  
  func testJsonArrayIsEmptyOnInitilialize() {
    let itemsIsEmpty = cardTableViewControllerUnderTest.items.isEmpty
    XCTAssertTrue(itemsIsEmpty, " Items array should be empty. Value was \(itemsIsEmpty)")
  }
  
  func testRefreshControllerAttributedText() {
    guard let refreshController = cardTableViewControllerUnderTest.refreshControl else {
      XCTFail("Refresh controller was nil")
      return
    }
    
    guard let attributedTitle = refreshController.attributedTitle else {
      XCTFail("Attributed title was nil")
      return
    }
    
    // Xcode adds {\n} to the string
    XCTAssertTrue(attributedTitle.description == "Pull to refresh stops{\n}", "Refresh controller attributed title set incorrectly. Value was \(attributedTitle.description)")
  }
}
