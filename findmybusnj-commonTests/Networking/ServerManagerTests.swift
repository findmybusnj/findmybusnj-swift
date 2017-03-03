//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by David Aghassi on 12/30/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import XCTest
@testable import findmybusnj_common

class ServerManagerTests: XCTestCase {
  // MARK: Test variables
  var networkManagerUnderTest: ServerManager!
  let testStop = "26229"
  var expect: XCTestExpectation?  // see: http://www.rockhoppertech.com/blog/unit-testing-async-network-calls-in-swift/

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.

    networkManagerUnderTest = ServerManager()
    if networkManagerUnderTest.lastEndpoint != "" {
      networkManagerUnderTest.lastEndpoint = ""
    }
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  /**
   Tests to make sure the `url` matches what it should be before use
   */
  func test_BaseURL_isCorrect() {
    XCTAssertEqual(networkManagerUnderTest.url,
                   "https://findmybusnj.com/rest",
                   "Base url should be https://findmybusnj.com/rest")
  }

  /**
   Tests to make sure `lastEndpoint` is an empty string before first use
   */
  func test_LastEndpoint_IsEmpty_BeforeUse() {
    XCTAssertEqual(networkManagerUnderTest.lastEndpoint, "", "`lastEndpoint` should be empty on first use")
  }
}
