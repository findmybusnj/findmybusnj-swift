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
    XCTAssertTrue(red == expectedRed)
  }
}
