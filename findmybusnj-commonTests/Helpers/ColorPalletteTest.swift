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
  var palletteUnderTest: ColorPallette!
  
  override func setUp() {
    super.setUp()
    palletteUnderTest = ColorPallette()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_Assert_powderBlue() {
    let powderBlue = palletteUnderTest.powderBlue()
    let components = CGColorGetComponents(powderBlue.CGColor)
    
    let red = components[0]
    let expectedRed = CGFloat(67.0/255.0)
    XCTAssertTrue(red == expectedRed, "Red of powderBlue is not correct. \n Expected: \(expectedRed) \n Actual: \(red) \n")
    
    let green = components[1]
    let expectedGreen = CGFloat(174.0/255.0)
    XCTAssertTrue(green == expectedGreen, "Green of powderBlue is not correct. \n Expected: \(expectedGreen) \n Actual: \(green)")
    
    let blue = components[2]
    let expectedBlue = CGFloat(249.0/255.0)
    XCTAssertTrue(blue == expectedBlue, "Blue of powderBlue is not correct. \n Expected: \(expectedBlue) \n Actual: \(blue)")
    
    let alpha = components[3]
    let expectedAlpha = CGFloat(1)
    XCTAssertTrue(alpha == expectedAlpha, "Alpha of powderBlue is not correct. \n Expected \(expectedAlpha) \n Actual: \(alpha)")
  }
}
