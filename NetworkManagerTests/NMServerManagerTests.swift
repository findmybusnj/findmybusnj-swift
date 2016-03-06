//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by David Aghassi on 12/30/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import XCTest
@testable import NetworkManager

class NMServerManagerTests: XCTestCase {
  // MARK: Test variables
  let testStop = "26229"
  var expect: XCTestExpectation?  // see: http://www.rockhoppertech.com/blog/unit-testing-async-network-calls-in-swift/
  
  override func setUp() {
    if NMServerManager.lastEndpoint != "" {
      NMServerManager.lastEndpoint = ""
    }
    
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  /**
   Tests to make sure the `url` matches what it should be before use
   */
  func testBaseURLisCorrect() {
    XCTAssertEqual(NMServerManager.url, "https://findmybusnj.com/rest", "Base url should be https://findmybusnj.com/rest")
  }
  
  /**
   Tests to make sure `lastEndpoint` is an empty string before first use
   */
  func testLastEndpointIsEmptyBeforeUse() {
    XCTAssertEqual(NMServerManager.lastEndpoint, "", "`lastEndpoint` should be empty on first use")
  }
}
