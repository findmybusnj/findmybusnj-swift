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

// MARK: Dependancies
import SwiftyJSON
import Alamofire
import Crashlytics

class FindNearByStopsController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  
  // How much to show outside of the center
  fileprivate let regionRadius: CLLocationDistance = 1000
  
  // location manager to authorize user location for Maps app
  var locationManager = CLLocationManager()
  let mapAlertPresenter = MapAlertPresenter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    locationManager.delegate = self
  
    // always check to make sure we have permission before proceeding.
    checkLocationAuthorizationStatus()
  }
  
  /**
   Sets the location of the user on the map
   */
  fileprivate func centerMapOnLocation() {
    guard let userLocation = locationManager.location else {
      return
    }
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
  /**
   Takes in a string that denotes the type of place to query google for,
   Sends a `.POST` request to the endpoint, which hits google, and returns JSON
   This method needs to be moved to the `ServerManager` eventually
   
   - parameter googleType: A string that represents the google types. You can find more
   info on the type at the [Google Places API](https://developers.google.com/places/supported_types)
   */
  fileprivate func queryPlaces(_ googleType: String) {
    #if RELEASE || TESTFLIGHT
      let coordinate = locationManager.location!.coordinate
    #endif
    
    let queryRegion = regionRadius * 5
    
    // Test data
    #if DEBUG
      let latitude = 40.9445783
      let longitude = -74.1051304
    #else
      // Prod code (variable based on GPS)
      let latitude = coordinate.latitude
      let longitude = coordinate.longitude
    #endif
    
    
    /**
     Pass data to server using headers, not through string
     */
    let url = String("https://findmybusnj.com/rest/getPlaces")
    let parameters = [
      "latitude" : String(latitude),
      "longitude" : String(longitude),
      "radius" : String(queryRegion),
      "types" : googleType
    ]
    #if DEBUG
      print(parameters)
    #endif
    
    Alamofire.request(.POST, url, parameters: parameters).responseJSON {
      [unowned self] response in
      let json = response.result
      
      if (json.isFailure) {
        if let error = json.error {
          Crashlytics.sharedInstance().recordError(error)
        }
      }
      else {
        // remove prior annotations if any
        self.mapView.removeAnnotations(self.mapView.annotations)
        let json = JSON(json.value!)
        #if DEBUG
          print(json)
        #endif
        
        let results = json["results"]
        var locName: String         // location name
        var latitude: Double
        var longitude: Double
        
        for i in 0.stride(to: results.count, by: 1) {
          locName = String(results[i]["name"])
          latitude = results[i]["geometry"]["location"]["lat"].double!
          longitude = results[i]["geometry"]["location"]["lng"].double!
          
          #if DEBUG
            print(i, "bus is:",  locName, "with latitude", latitude, "and longitude", longitude)
          #endif
          let busStopAnnotation = PlacesAnnotation(title: locName, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
          self.mapView.addAnnotation(busStopAnnotation)
        }
      }
    }
  }
  
  /**
   Checks to see if the user has authorized use of location services
   */
  fileprivate func checkLocationAuthorizationStatus() {
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      mapView.showsUserLocation = true
      centerMapOnLocation()
      queryPlaces("bus_station")
    }
    else {
      mapView.showsUserLocation = false
      locationManager.requestWhenInUseAuthorization()
    }
  }
}

// MARK: MKMapViewDelegate
extension FindNearByStopsController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if let annotation = annotation as? PlacesAnnotation {
      let identifier = "pin"
      var view: MKPinAnnotationView
      
      if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
        dequeuedView.annotation = annotation
        view = dequeuedView
      }
      else {
        let button = UIButton(type: .detailDisclosure)
        button.setImage(UIImage(named: "Car"), for: UIControlState())
        
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = button
        view.animatesDrop = true
        return view
      }
    }
    
    return nil
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    let location = view.annotation as! PlacesAnnotation
    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
    location.mapItem().openInMaps(launchOptions: launchOptions)
  }
}

// MARK: CLLocationManagerDelegate
extension FindNearByStopsController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // update if we can display the user location and use GPS
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      mapView.showsUserLocation = true
      centerMapOnLocation()
      queryPlaces("bus_station")
    case .denied, .restricted, .notDetermined:
      mapView.showsUserLocation = false
      mapView.removeAnnotations(mapView.annotations)
      // Show notification stating location services need enabling
      let alertController = mapAlertPresenter.presentAlertWarning(status)
      present(alertController, animated: true, completion: nil)
    }
  }
}
