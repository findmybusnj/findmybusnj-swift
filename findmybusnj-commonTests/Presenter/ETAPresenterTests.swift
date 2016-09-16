//
//  ETAPresenter.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/23/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import XCTest
@testable import findmybusnj_common

class ETAPresenterTests: XCTestCase {
  var presenterUnderTest: MockPresenter!
  let colorPallette = ColorPalette()
  var time: Int = 0
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    presenterUnderTest = MockPresenter()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    time = 0
    super.tearDown()
  }
  
  /**
   Asserts the actual color recieved is `==` to that of the expected
   
   - parameter actual:   Actual `UIColor`
   - parameter expected: Expected `UIColor`
   - parameter name:     The name of the color function being tested
   */
  func assertColorsAreEqual(_ actual: UIColor, expected: UIColor, name: String) {
    XCTAssertTrue(actual == expected, "The actual color of \(name) was different from the expected. \n Expected: \(expected) \n Actual: \(actual). \n See line \(#line)")
  }
  
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
}
