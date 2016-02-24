//
//  ETABusTimeTableUnitTests.swift
//
//
//  Created by David Aghassi on 2/24/16.
//
//

import XCTest
@testable import findmybusnj

class ETABusTimeTableUnitTests: XCTestCase {
  var controller: ETABusTimeTableController!
  
  override func setUp() {
    super.setUp()
    
    controller = ETABusTimeTableController()
    XCTAssertNotNil(controller.view)
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
}
