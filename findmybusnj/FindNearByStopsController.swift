//
//  FindNearByStopsController.swift
//  findmybusnj
//
//  Created by David Aghassi on 9/29/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FindNearByStopsController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    // How much to show outside of the center
    let regionRadius: CLLocationDistance = 1000
    // MARK: - location manager to authorize user location for Maps app
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    
    func centerMapOnLocation() {
        let userlocation = locationManager
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(userlocation.location!.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}