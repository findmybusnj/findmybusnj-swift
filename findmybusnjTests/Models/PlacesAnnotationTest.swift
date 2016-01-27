//
//  PlacesAnnotationTest.swift
//  findmybusnj
//
//  Created by David Aghassi on 1/26/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import XCTest
import MapKit
@testable import findmybusnj

/**
 Contains the tests for the `PlacesAnnotation` file
 */
class PlacesAnnotationTest: XCTestCase {
  var annotation: PlacesAnnotation?
  
  override func setUp() {
    super.setUp()
    
    // test coordinates
    let latitude = 40.9171205
    let longitude = -74.0441104
    
    let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    annotation = PlacesAnnotation(title: "Test annotation", coordinate: coordinates)
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  /**
   Verifies that the `subtitle` property is nil after initialization.
   */
  func testSubtitleIsNil() {
    guard let marker = annotation else {
      return
    }
    XCTAssertNil(marker.subtitle, "After initialization, subtitle should be nil")
  }
}