//
//  JSONSanitizerTests.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/25/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import findmybusnj_common

class JSONSanitizerTests: XCTestCase {
  var sanitizerUnderTest: JSONSanitizer!
  var json: JSON = []
  
  override func setUp() {
    super.setUp()
    sanitizerUnderTest = JSONSanitizer()
    json = loadJSONFromFile(JSONFileName.singleStop.rawValue)[0]
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  /**
   Asserts that getSanatizedArrivalTimeAsString returns the proper value from `["pu"]` subscript and is of type String
   */
  func test_getSanatizedArrivalTimeAsString() {
    let expected = json["pu"].description
    let actual = sanitizerUnderTest.getSanatizedArrivalTimeAsString(json)
    XCTAssertTrue(actual.dynamicType == String.self, "Returned value was not a String. Please see line \(#line) \n Expected a String \n Actual was \(actual.dynamicType)")
    XCTAssertTrue(expected == actual, "Actual json is not what was expected. \n Expected is \(expected) \n Actual is \(actual).")
  }
  
  func test_getSanitizedArrivaleTimeAsInt_For_Number() {
    let expected = Int(json["pt"].description)
    let actual = sanitizerUnderTest.getSanitizedArrivaleTimeAsInt(json)
    XCTAssertTrue(actual.dynamicType == Int.self, "Returned value was not an Int. Please see line \(#line) \n Expected an Int \n Actual was \(actual.dynamicType)")
    XCTAssertTrue(expected == actual, "Actual json is not what was expected \n Expected is \(expected) \n Actual is \(actual)")
  }
  
  func test_getSanitizedArrivaleTimeAsInt_For_Null() {
    let tempJson = loadJSONFromFile(JSONFileName.noPrediction.rawValue)
    let expected = -1
    let actual = sanitizerUnderTest.getSanitizedArrivaleTimeAsInt(tempJson)
    XCTAssertTrue(actual.dynamicType == Int.self, "Returned value was not an Int. Please see line \(#line) \n Expected an Int \n Actual was \(actual.dynamicType)")
    XCTAssertTrue(expected == actual, "Actual json is not what was expected \n Expected is \(expected) \n Actual is \(actual) ")
  }
  
  func test_getSanitizedRouteNumber() {
    let expected = json["rd"].description
    let actual = sanitizerUnderTest.getSanitizedRouteNumber(json)
    XCTAssertTrue(actual.dynamicType == String.self, "Returned value was not a String. Please see line \(#line) \n Expected a String \n Actual was \(actual.dynamicType)")
    XCTAssertTrue(expected == actual, "Actual json is not what was expected. \n Expected is \(expected) \n Actual is \(actual) ")
  }
  
  func test_getSanitizedRouteDescription() {
    let expected = json["fd"].description.lowercaseString.capitalizedString
    let actual = sanitizerUnderTest.getSanitizedRouteDescription(json)
    XCTAssertTrue(actual.dynamicType == String.self, "Returned value was not a String. Please see line \(#line) \n Expected a String \n Actual was \(actual.dynamicType)")
    XCTAssertTrue(!actual.containsString("&amp;"), "Sanitized string should not contain \"&amp;\". Please see line \(#line) for more details.")
    XCTAssertTrue(expected == actual, "Actual json is not what was expected \n Expected is \(expected) \n Actual is \(actual) ")
  }
}
