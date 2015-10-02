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
import SwiftyJSON
import Alamofire

class FindNearByStopsController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    // How much to show outside of the center
    private let regionRadius: CLLocationDistance = 1000
    private let kgPlaceKey = "AIzaSyDW23sbbtOyMigIWLlIwJar8bOVv-3g1ZU"
    private let kBgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    // MARK: - location manager to authorize user location for Maps app
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation()
        queryPlaces("bus_station")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

    
    private func centerMapOnLocation() {
        let userlocation = locationManager
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(userlocation.location!.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func queryPlaces(googleType: String) {
        let coordinate = locationManager.location!.coordinate
        let queryRegion = regionRadius * 3
        let url = String.init(format: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%@&key=%@", coordinate.latitude, coordinate.longitude, String.init(format: "%i", queryRegion), kgPlaceKey)
        
        Alamofire.request(.GET, url).responseJSON {
            response in response
            print(response)
        }
    }
    
    private func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}