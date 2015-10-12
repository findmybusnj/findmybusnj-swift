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

class PlacesAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
