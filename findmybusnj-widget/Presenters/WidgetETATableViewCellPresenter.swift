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

class WidgetTodayViewCellPresenter: ETAPresenter {
  var sanitizer = JSONSanitizer()
  let colorPallette = ColorPalette()
  
  func formatCellForPresentation(_ cell: UITableViewCell, json: JSON) {
    assignArrivalTimeForJson(cell, json: json)
    assignBusAndRouteTextForJson(cell, json: json)
  }
  
  /**
    Asssigns the arrival time to the given table view cell for the json provided.
    If the time is not a number, we assign it Arriving/Delayed/No Current Prediction
 
    - TODO: Refactor this method to move similar logic to `ETAPresenter` so logic isn't duplicated from `ETACardPresenter`
 
    - Parameters:
    - card:   table view cell being edited
    - json:   The json at the current index
  */
  func assignArrivalTimeForJson(_ cell: UITableViewCell, json: JSON) {
    guard let currentCell = cell as? WidgetETATableViewCell else {
      return
    }
    currentCell.timeLabel.textColor = UIColor.white
    currentCell.timeLabel.adjustsFontSizeToFitWidth = true
    
    let arrivalString = sanitizer.getSanatizedArrivalTimeAsString(json)
    let arrivalTime = sanitizer.getSanitizedArrivaleTimeAsInt(json)
    
    if arrivalTime != -1 {
      if arrivalTime ==  NumericArrivals.arrived.rawValue {
        currentCell.timeLabel.text = "Arrived"
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
      
      let nonZeroArrivalString = determineNonZeroArrivalString(arrivalString: arrivalString)
      currentCell.timeLabel.text = nonZeroArrivalString
      
      switch arrivalString {
      case NonNumericaArrivals.APPROACHING.rawValue:
        currentCell.etaView.backgroundColor = colorPallette.powderBlue()
      case NonNumericaArrivals.DELAYED.rawValue:
        currentCell.etaView.backgroundColor = colorPallette.lollipopRed()
      default:
        currentCell.timeLabel.textColor = UIColor.blue
        currentCell.etaView.backgroundColor = UIColor.clear
      }
    }
  }
  
  func assignBusAndRouteTextForJson(_ cell: UITableViewCell, json: JSON) {
    guard let currentCell = cell as? WidgetETATableViewCell else {
      return
    }
    
    if #available(iOS 10.0, *) {
        // no-op
    }
    else {
        // for versions less than ios 10, we display white text
        currentCell.routeLabel.textColor = UIColor.white
        currentCell.routeDescriptionLabel.textColor = UIColor.white
    }
    
    currentCell.routeLabel.text = sanitizer.getSanitizedRouteNumber(json)
    currentCell.routeDescriptionLabel.text = sanitizer.getSanitizedRouteDescription(json)
    currentCell.routeDescriptionLabel.adjustsFontSizeToFitWidth = true
  }
}
