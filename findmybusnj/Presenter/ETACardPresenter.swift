//
//  ETACardPresenter.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/8/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit

// MARK: Dependencies
import SwiftyJSON
import findmybusnj_common

// Handles laying out an `ETACard` for a `ETACardTableView`
class ETACardPresenter: ETAPresenter {
  var sanitizer = JSONSanitizer()
  
  /**
   Formats the given `ETACard` for the `json` at the provided row
   
   - parameter card:  ETACard for the given reusable cell
   - parameter json:  json for the given row in the table
   */
  func formatCellForPresentation(_ cell: UITableViewCell, json: JSON) {
    assignArrivalTimeForJson(cell, json: json)
    assignBusAndRouteTextForJson(cell, json: json)
  }
  
  /**
   Assigns the arrival time to the given card given the json at that index
   If the time is not a number, we assign it Arriving/Delayed/No Current Prediction
   
   - TODO: Refactor the render method to make it loosely coupled.
   
   - Parameters:
   - card:   The card in the tableview being edited
   - json:   The json at the current index.
   */
  func assignArrivalTimeForJson(_ cell: UITableViewCell, json: JSON) {
    guard let currentCell = cell as? ETACard else {
      return
    }
    
    let arrivalString = sanitizer.getSanatizedArrivalTimeAsString(json)
    let arrivalTime = sanitizer.getSanitizedArrivaleTimeAsInt(json)
    
    // Reset to black everytime just in case
    currentCell.timeLabel.textColor = UIColor.black
    
    if arrivalTime != -1 {
      if arrivalTime ==  NumericArrivals.ARRIVED.rawValue {
        currentCell.timeLabel.text = "Arrive"
        currentCell.timeLabel.textColor = UIColor.white
        currentCell.renderFilledCircleForBusTime(arrivalTime) // We know this will be 0 at this point
      }
      else {
        currentCell.timeLabel.text = arrivalTime.description + " min."
        // We also render the circle here
        currentCell.renderCircleForBusTime(arrivalTime)
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
        currentCell.timeLabel.textColor = UIColor.white
        currentCell.renderFilledCircleForBusTime(0)
      case NonNumericaArrivals.DELAYED.rawValue:
        currentCell.timeLabel.text = "Delay"
        currentCell.timeLabel.textColor = UIColor.white
        currentCell.renderFilledCircleForBusTime(35)
      default:
        currentCell.timeLabel.text = "0"
        currentCell.timeLabel.textColor = UIColor.blue
      }
    }

  }
  
  /**
   Assigns the bus number (e.g. `165`) to `busNumberLabel`, and assigns the
   route (e.g. `165 via NJ Turnpike`) to `route`.
   
   - Parameters:
   - card: The custom table view card we are modifying the values of
   - json: The json at the current index
   */
  func assignBusAndRouteTextForJson(_ cell: UITableViewCell, json: JSON) {
    guard let currentCell = cell as? ETACard else {
      return
    }
    
    let route = sanitizer.getSanitizedRouteDescription(json)
    
    currentCell.busNumberLabel.text = sanitizer.getSanitizedRouteNumber(json)
    currentCell.routeLabel.text = route
    currentCell.routeLabel.adjustsFontSizeToFitWidth = true
  }
}
