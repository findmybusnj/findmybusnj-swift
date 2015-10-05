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
    private let kgPlaceKey = "AIzaSyB5pvxDYulLut0SLlHUep33ufjJ7OxUQ5M"
    // MARK: - location manager to authorize user location for Maps app
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerMapOnLocation()
        queryPlaces("bus_station")
    }
    
    override func viewWillAppear(animated: Bool) {
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
        
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        let url = String("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(queryRegion)&types=\(googleType)&key=\(kgPlaceKey)")
        
        Alamofire.request(.GET, url).responseJSON {
            (req, res, result) in
            if (result.isFailure) {
                NSLog("Error: \(result.error)")
            }
            else {
                if let json = result.value {
                    print("JSON: ", json["results"])
                }
            }
        }
    }
    
    private func addMapAttributesForPlaces(json: JSON) {
        
    }
    
    private func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}