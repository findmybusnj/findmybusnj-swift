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
      let alertController = UIAlertController.init(title: "Please enable location service", message: "To see near by bus stops, location services needs to be enabled. Please go to Settings -> Privacy -> Location Services and enable it for this app.", preferredStyle: .alert)
      let done = UIAlertAction(title: "Done", style: .default, handler: nil)
      alertController.addAction(done)
      return alertController
    default:
      return UIAlertController(title: "", message: "", preferredStyle: .alert)
    }
  }
}
