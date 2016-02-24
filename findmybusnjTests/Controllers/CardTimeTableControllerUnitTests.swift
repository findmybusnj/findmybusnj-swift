//
//  CardTimeTableControllerUnitTests.swift
//  findmybusnj
//
//  Created by David Aghassi on 2/24/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import XCTest
@testable import findmybusnj

class CardTimeTableControllerUnitTests: XCTestCase {
  var controller: CardTableViewController!
  
  override func setUp() {
    super.setUp()
    
    controller = CardTableViewController()
    XCTAssertNotNil(controller.view)
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testNoPredictionInitializesToFalse() {
    XCTAssertFalse(controller.noPrediction, "No prediction should be false after initialization")
  }
  
  func testJsonArrayIsEmptyOnInitilialize() {
    XCTAssertTrue(controller.items.isEmpty, "Items array should be empty.")
  }
}
