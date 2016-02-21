//
//  FNBSMapView.swift
//  findmybusnj
//
//  Created by David Aghassi on 10/12/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import MapKit

// MARK: MKMapViewDelegate
extension FindNearByStopsController: MKMapViewDelegate {
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if let annotation = annotation as? PlacesAnnotation {
      let identifier = "pin"
      var view: MKPinAnnotationView
      
      if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
        dequeuedView.annotation = annotation
        view = dequeuedView
      }
      else {
        let button = UIButton(type: .DetailDisclosure)
        button.setImage(UIImage(named: "Car"), forState: .Normal)
        
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = button
        return view
      }
    }
    
    return nil
  }
  
  func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    let location = view.annotation as! PlacesAnnotation
    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
    location.mapItem().openInMapsWithLaunchOptions(launchOptions)
  }
}