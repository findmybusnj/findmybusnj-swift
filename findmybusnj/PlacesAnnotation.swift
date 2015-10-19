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
import AddressBook

class PlacesAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return nil
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): String(title)]      // MKPlacemark only takes a String, not an optional string
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}
