//
//  MapAlertPresenter.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/9/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit
import MapKit

extension CLAuthorizationStatus: AlertEnum {

}

struct MapAlertPresenter: UIAlertPresenter {

  func presentAlertWarning(_ type: AlertEnum) -> UIAlertController {
    switch type {
    case CLAuthorizationStatus.denied, CLAuthorizationStatus.restricted, CLAuthorizationStatus.notDetermined:
      let alertController = UIAlertController.init(title: "Please enable location service",
                                                   message: "To see near by bus stops, location services needs to be enabled. Please enable it for this app.",
                                                   preferredStyle: .alert)
      let settings = UIAlertAction(title: "Settings",
                               style: .default) { (_) -> Void in
                                guard let settingsURL = URL(string:"prefs:root=LOCATION_SERVICES") else {
                                  return
                                }
                                
                                if UIApplication.shared.canOpenURL(settingsURL) {
                                  if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(settingsURL)
                                  } else {
                                    // Fallback on earlier versions
                                    UIApplication.sharedApplication().openURL(settingsURL)
                                  }
                                }
      }
      alertController.addAction(settings)
      return alertController
    default:
      return UIAlertController(title: "", message: "", preferredStyle: .alert)
    }
  }
}
