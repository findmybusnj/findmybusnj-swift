//
//  WidgetETATableViewCellPresenter.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/19/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit

// Dependencies
import SwiftyJSON
import findmybusnj_common

class WidgetETATableViewCellPresenter: ETAPresenter {
  var sanitizer = JSONSanitizer()
  let colorPallette = ColorPallette()
  
  func formatCellForPresentation(cell: UITableViewCell, json: JSON) {
    assignArrivalTimeForJson(cell, json: json)
    assignBusAndRouteTextForJson(cell, json: json)
  }
  
  func assignArrivalTimeForJson(cell: UITableViewCell, json: JSON) {
    guard let currentCell = cell as? WidgetETATableViewCell else {
      return
    }
    currentCell.timeLabel.textColor = UIColor.whiteColor()
    
    let arrivalString = sanitizer.getSanatizedArrivalTimeAsString(json)
    let arrivalTime = sanitizer.getSanitizedArrivaleTimeAsInt(json)
    
    if arrivalTime != -1 {
      if arrivalTime ==  NumericArrivals.ARRIVED.rawValue {
        currentCell.timeLabel.text = "Arrive"
        currentCell.etaView.backgroundColor = colorPallette.powderBlue()
      }
      else {
        currentCell.timeLabel.text = arrivalTime.description + " min."
        currentCell.etaView.backgroundColor = backgroundColorForTime(arrivalTime)
      }
    }
    else {
      #if DEBUG
        print(arrivalString)
        print(json)
      #endif
      
      switch arrivalString {
      case NonNumericaArrivals.APPROACHING.rawValue:
        currentCell.timeLabel.text = "Arrive"
        currentCell.etaView.backgroundColor = colorPallette.powderBlue()
      case NonNumericaArrivals.DELAYED.rawValue:
        currentCell.timeLabel.text = "Delay"
        currentCell.etaView.backgroundColor = colorPallette.lollipopRed()
      default:
        currentCell.timeLabel.text = "0"
        currentCell.timeLabel.textColor = UIColor.blueColor()
        currentCell.etaView.backgroundColor = UIColor.clearColor()
      }
    }
  }
  
  func assignBusAndRouteTextForJson(cell: UITableViewCell, json: JSON) {
    guard let currentCell = cell as? WidgetETATableViewCell else {
      return
    }
    
    currentCell.routeLabel.textColor = UIColor.whiteColor()
    currentCell.routeDescriptionLabel.textColor = UIColor.whiteColor()
    
    currentCell.routeLabel.text = sanitizer.getSanitizedRouteNumber(json)
    currentCell.routeDescriptionLabel.text = sanitizer.getSanitizedRouteDescription(json)
    currentCell.routeDescriptionLabel.adjustsFontSizeToFitWidth = true
  }
}
