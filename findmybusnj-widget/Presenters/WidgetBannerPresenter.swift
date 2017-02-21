//
//  WidgetBannerPresenter.swift
//  findmybusnj
//
//  Created by David Aghassi on 2/21/17.
//  Copyright © 2017 David Aghassi. All rights reserved.
//

import UIKit

// Dependencies
import SwiftyJSON
import findmybusnj_common

/**
 Class for managing the next bus banner at the top of the widget
 */
class WidgetBannerPresenter: ETAPresenter {
  var sanitizer = JSONSanitizer()
  
  /**
   Assigns the banner the proper string based on the current arrival information
  */
  func assignTextForArrivalBanner(label: UILabel, json: JSON) {
    label.text = "The next bus will be"
    let arrivalCase = determineArrivalCase(json: json)
    
    switch arrivalCase {
    case "Arrived":
      label.text = "The next bus has \(arrivalCase.lowercased())"
      return
    case"Arriving":
      label.text = "The next bus is \(arrivalCase.lowercased())"
      return
    case "Delay":
      label.text = "\(label.text ?? "") delayed"
      return
    default:
      let arrivalTime = sanitizer.getSanitizedArrivaleTimeAsInt(json)
      label.text = "\(label.text ?? "") \(arrivalTime.description) min."
      return
    }
  }
  
  // no-ops since they aren't used by this presenter
  func formatCellForPresentation(_ cell: UITableViewCell, json: JSON) {}
  func assignArrivalTimeForJson(_ cell: UITableViewCell, json: JSON) {}
  func assignBusAndRouteTextForJson(_ cell: UITableViewCell, json: JSON) {}
}
