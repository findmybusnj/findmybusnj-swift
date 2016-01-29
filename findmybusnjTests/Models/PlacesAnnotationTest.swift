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
  let title = "Test annotation"
  
  // test coordinates
  let latitude = 40.9171205
  let longitude = -74.0441104
  
  // MARK: Setup
  override func setUp() {
    super.setUp()
    
    let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    annotation = PlacesAnnotation(title: self.title, coordinate: coordinates)
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: PlacesAnnotation
  /**
   Verifies that the `subtitle` property is nil after initialization.
   */
  func testSubtitleIsNil() {
    guard let marker = annotation else {
      return
    }
    
    XCTAssertNil(marker.subtitle, "After initialization, subtitle should be nil")
  }
  
  /**
   Verifies the name is the same as we initialized
   */
  func testTitleIsSameTitle() {
    guard let marker = annotation else {
      return
    }
    
    XCTAssertEqual(marker.title, self.title, "Titles should be the same")
  }
  
  /**
   Verifies the coordinates we passed in are the same
   */
  func testCoordinatesAreTheSame() {
    guard let marker = annotation else {
      return
    }
    
    XCTAssertEqual(marker.coordinate.latitude, self.latitude, "Latitudes should match")
    XCTAssertEqual(marker.coordinate.longitude, self.longitude, "Longitudes should match")
  }
  
  // MARK: MKAnnotation extention
  /**
   Verifies the method `mapItem` returns a `MKMapItem`
   */
  func testMapItemIsMKMapItem() {
    guard let marker = annotation else {
      return
    }
    
    let mapItem = marker.mapItem()
    XCTAssertTrue(mapItem.isKindOfClass(MKMapItem), "Function .mapItem() should return a MKMapItem")
  }
  
  func testMapItemTitleMatches() {
    guard let marker = annotation else {
      return
    }
    
    let mapItem = marker.mapItem()
    XCTAssertEqual(mapItem.placemark.title, self.title, "mapItem title should match given title")
  }
  
  func testMapItemLocationMatches() {
    guard let marker = annotation else {
      return
    }
    
    let mapItem = marker.mapItem()
    guard let mapLocation = mapItem.placemark.location else {
      return
    }
    XCTAssertEqual(mapLocation.coordinate.longitude, self.longitude, "mapItem longitude should match given longitude")
    XCTAssertEqual(mapLocation.coordinate.latitude, self.latitude, "mapItem latitude should match given latitude")
  }
}