//
//  ColorPalletteTest.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/20/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import XCTest
import CoreGraphics
@testable import findmybusnj_common

class ColorPalletteTest: XCTestCase {
  var palletteUnderTest: ColorPalette!
  
  override func setUp() {
    super.setUp()
    palletteUnderTest = ColorPalette()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  /**
   Asserts the given array of colors matches the expected array of colors.
   
   - parameter components:         Array of `UnsafePointer<CGFloat>` that is generated from `CGColorGetComponents`
   - parameter expectedComponents: Hardcoded array of expected values as `[CGFloat]`
   - parameter name:               Name of the method being tested
   */
  func assertCorrectRGB(_ components: UnsafePointer<CGFloat>, expectedComponents: [CGFloat], name: String) {
    let red = components[0]
    let expectedRed = expectedComponents[0]
    XCTAssertTrue(red == expectedRed, "Red of \(name) is not correct. \n Expected: \(expectedRed) \n Actual: \(red) \n")
    
    let green = components[1]
    let expectedGreen = expectedComponents[1]
    XCTAssertTrue(green == expectedGreen, "Green of \(name) is not correct. \n Expected: \(expectedGreen) \n Actual: \(green)")
    
    let blue = components[2]
    let expectedBlue = expectedComponents[2]
    XCTAssertTrue(blue == expectedBlue, "Blue of \(name) is not correct. \n Expected: \(expectedBlue) \n Actual: \(blue)")
    
    let alpha = components[3]
    let expectedAlpha = expectedComponents[3]
    XCTAssertTrue(alpha == expectedAlpha, "Alpha of \(name) is not correct. \n Expected \(expectedAlpha) \n Actual: \(alpha)")
  }
  
  func test_Assert_powderBlue() {
    let powderBlue = palletteUnderTest.powderBlue()
    if let components = powderBlue.cgColor.components {
      let expectedComponents = [CGFloat(67.0/255.0), CGFloat(174.0/255.0), CGFloat(249.0/255.0), CGFloat(1)]
      
      assertCorrectRGB(components, expectedComponents: expectedComponents, name: "powderBlue")
    }
    else {
      XCTFail()
    }
  }
  
  func test_Assert_emeraldGreen() {
    let emeraldGreen = palletteUnderTest.emeraldGreen()
    if let components = emeraldGreen.cgColor.components {
      let expectedComponents = [CGFloat(29.0/255.0), CGFloat(156.0/255.0), CGFloat(48.0/255.0), CGFloat(1)]
      
      assertCorrectRGB(components, expectedComponents: expectedComponents, name: "emeraldGreen")
    }
    else {
      XCTFail()
    }
  }
  
  func test_Assert_creamsicleOrange() {
    let creamsicleOrange = palletteUnderTest.creamsicleOrange()
    if let components = creamsicleOrange.cgColor.components {
      let expectedComponents = [CGFloat(237.0/255.0), CGFloat(145.0/255.0), CGFloat(50.0/255.0), CGFloat(1)]
      
      assertCorrectRGB(components, expectedComponents: expectedComponents, name: "creamsicleOrange")
    }
    else {
      XCTFail()
    }
  }
  
  func test_Assert_lollipopRed() {
    let lollipopRed = palletteUnderTest.lollipopRed()
    if let components = lollipopRed.cgColor.components {
      let expectedComponents = [CGFloat(204.0/255.0), CGFloat(25.0/255.0), CGFloat(36.0/255.0), CGFloat(1)]
      
      assertCorrectRGB(components, expectedComponents: expectedComponents, name: "lollipopRed")
    }
    else {
      XCTFail()
    }
  }
}
