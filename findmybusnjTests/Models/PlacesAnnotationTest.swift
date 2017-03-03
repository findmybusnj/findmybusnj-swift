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
  let latitude = 40.9445783
  let longitude = -74.1051304

  // MARK: Setup
  /**
   Creates a new annotation based on the given coordinates and title
   */
  override func setUp() {
    super.setUp()

    let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    annotation = PlacesAnnotation(title: self.title, coordinate: coordinates)
  }

  // MARK: Tests
  /**
   Verifies that the `subtitle` property is nil after initialization.
   */
  func test_Subtitle_IsNil() {
    guard let marker = annotation else {
      return
    }

    XCTAssertNil(marker.subtitle, "After initialization, subtitle should be nil")
  }

  /**
   Verifies the name is the same as we initialized
   */
  func test_Title_IsSameTitle() {
    guard let marker = annotation else {
      return
    }

    XCTAssertEqual(marker.title, self.title, "Titles should be the same")
  }

  /**
   Verifies the coordinates we passed in are the same
   */
  func test_Annotation_Coordinates_AreTheSame() {
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
  func test_MapItem_IsMKMapItem() {
    guard let marker = annotation else {
      return
    }

    let mapItem = marker.mapItem()
    XCTAssertTrue(mapItem.isKind(of: MKMapItem.self), "Function .mapItem() should return a MKMapItem")
  }

  /**
   Checks to see that the title was properly set on `mapItem`. 
   By default, "United States" is appended to all titles, so we have to check that we contain
   the string, and not that they match exactly
   */
  func test_MapItemTitle_ContainsTitle() {
    guard let marker = annotation else {
      return
    }

    let mapItem = marker.mapItem()
    if let markerName = mapItem.name {
      let containsString = markerName.range(of: self.title) != nil
      XCTAssertTrue(containsString, "mapItem should match title")
    } else {
      XCTAssertFalse(false, "placemarkTitle was not unwrapped properly")
    }

  }

  /**
   Checks to see that the location was properly set on `mapItem`
   */
  func test_MapItemLocation_Matches() {
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
