//
//  ETAPresenter.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/23/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import XCTest

// Dependancies
import SwiftyJSON

@testable import findmybusnj_common

class ETAPresenterTests: XCTestCase {
  var presenterUnderTest: MockPresenter!
  let colorPallette = ColorPalette()
  
  // MARK: Test Variables
  var time: Int = 0
  var testArrivalString: String = ""
  var json: JSON = []
  
  override func setUp() {
    super.setUp()
    
    presenterUnderTest = MockPresenter()
    json = loadJSONFromFile(JSONFileName.singleStop.rawValue)
  }
  
  override func tearDown() {
    time = 0
    super.tearDown()
  }
  
  // MARK: Helper Methods
  /**
   Asserts the actual color recieved is `==` to that of the expected
   
   - parameter actual:   Actual `UIColor`
   - parameter expected: Expected `UIColor`
   - parameter name:     The name of the color function being tested
   */
  func assertColorsAreEqual(_ actual: UIColor, expected: UIColor, name: String) {
    XCTAssertTrue(actual == expected, "The actual color of \(name) was different from the expected. \n Expected: \(expected) \n Actual: \(actual). \n See line \(#line)")
  }
  
  /**
   Asserts that the test string provided generates the expected string provided using the `determineNonZeroArrivalString` function.
   
   - parameter testString: The string being provided for comprison
   - parameter expected: The string we expect to get back from the test string
   */
  func assertNonZeroStringsAreEqual(testString: String, expected: String) {
    let actualReturnString = presenterUnderTest.determineNonZeroArrivalString(arrivalString: testString)
    
    XCTAssertEqual(expected, actualReturnString, "Expected \(expected), but instead found \(actualReturnString)")

  }
  
  /**
   Asserts that the expected enum `rawValue` is equal to the string being passed in.

   - paremeter expected: The expected string representation of the enum's raw value
   - parameter actual: The enum passed in using the `rawValue` property
   */
  func assertNonNumericEnumsAreEqual(expected: String, actual: String) {
    XCTAssertEqual(expected, actual, "NonNumericArrivals case is different than expected. \n Expected: \(expected) \n Actual: \(actual)")
  }

  // MARK: Background Color Tests
  func test_Assert_backgroundColorForTime_Zero_Returns_PowderBlue() {
    time = 0
    let expectedColor = colorPallette.powderBlue()
    let actualColor = presenterUnderTest.backgroundColorForTime(time)
    
    assertColorsAreEqual(actualColor, expected: expectedColor, name: "powderBlue")
  }
  
  func test_Assert_backgroundColorForTime_Between_Zero_And_Seven_Returns_EmeraldGreen() {
    time = 6
    let expectedColor = colorPallette.emeraldGreen()
    let actualColor = presenterUnderTest.backgroundColorForTime(time)
    
    assertColorsAreEqual(actualColor, expected: expectedColor, name: "emeraldGreen")
  }
  
  func test_Assert_backgroundColorForTime_Between_Seven_And_Fourteen_Returns_CreamsicleOrange() {
    time = 12
    let expectedColor = colorPallette.creamsicleOrange()
    let actualColor = presenterUnderTest.backgroundColorForTime(time)
    
    assertColorsAreEqual(actualColor, expected: expectedColor, name: "creamsicleOrange")
  }
  
  func test_Assert_backgroundcolorForTime_GreaterThan_Fourteen_Returns_LollipopRed() {
    time = 21
    let expectedColor = colorPallette.lollipopRed()
    let actualColor = presenterUnderTest.backgroundColorForTime(time)
    
    assertColorsAreEqual(actualColor, expected: expectedColor, name: "lollipopRed")
  }
  
  // MARK: Determine Non Zero Arrivals Tests
  func test_Assert_determineNonZeroArrivalString_For_APPROACHING() {
    assertNonZeroStringsAreEqual(testString: "APPROACHING", expected: "Arriving")
  }
  
  func test_Assert_determineNonZeroArrivalString_For_DELAYED() {
    assertNonZeroStringsAreEqual(testString: "DELAYED", expected: "Delay")
  }
  
  func test_Assert_determineNonZeroArrivalString_For_Default() {
    assertNonZeroStringsAreEqual(testString: "0", expected: "0")
  }

  // MARK: Enum Tests
  func test_Assert_NonNumericArrivals_APPROACHING() {
    assertNonNumericEnumsAreEqual(expected: "APPROACHING", actual: NonNumericArrivals.APPROACHING.rawValue)
  }

  func test_Assert_NonNumericArrivals_DELAYED() {
    assertNonNumericEnumsAreEqual(expected: "DELAYED", actual: NonNumericArrivals.DELAYED.rawValue)
  }
}
