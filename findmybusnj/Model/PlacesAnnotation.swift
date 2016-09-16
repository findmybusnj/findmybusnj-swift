//
//  PlacesAnnotation.swift
//  Creates an annotation for buses on map
//  findmybusnj
//
//  Created by David Aghassi on 10/12/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class PlacesAnnotation: NSObject {
  // MARK: Properties
  let title: String?
  let coordinate: CLLocationCoordinate2D
  
  // inititalize the subtitle variable to nil so we don't have one
  var subtitle: String? {
    return nil
  }
  
  /**
   Initializer method to create a new annotation with a name and coordinates
   
   - Parameters:
     - title: Title of the place marker
     - coordinate: The `CLLocationCoordinate2D` that defines the x,y coordinates for the annotation
   */
  init(title: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.coordinate = coordinate
    
    super.init()
  }
  
}

// MARK: MKAnnotation
extension PlacesAnnotation: MKAnnotation {
  /**
   Creates an `MKMapItem` based on the `MKPlacemark` created out of this current object coordinates and title
   
   - returns: An MKMapItem containing the title and coordinates of the annotation
   */
  func mapItem() -> MKMapItem {
    let addressDictionary = [String(CNPostalAddress().street): String(describing: title)]      // MKPlacemark only takes a String, not an optional string
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
    
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = title
    
    return mapItem
  }
}
