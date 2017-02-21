//
//  ETAPresenter.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/19/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit

// Dependecies
import SwiftyJSON

/**
 *  Base protocol representing a presenter that handles ETA cell formatting
 */
public protocol ETAPresenter {
  var sanitizer: JSONSanitizer { get set }
  func formatCellForPresentation(_ cell: UITableViewCell, json: JSON)
  func assignArrivalTimeForJson(_ cell: UITableViewCell, json: JSON)
  func assignBusAndRouteTextForJson(_ cell: UITableViewCell, json: JSON)
}

public extension ETAPresenter {
  func determineArrivalCase(json: JSON) -> String {
    let arrivalString = sanitizer.getSanatizedArrivalTimeAsString(json)
    let arrivalTime = sanitizer.getSanitizedArrivaleTimeAsInt(json)
    
    if arrivalTime != -1 {
      if arrivalTime ==  NumericArrivals.arrived.rawValue {
        return "Arrived"
      }
      else {
        return "Minutes"
      }
    }
    else {
      #if DEBUG
        print(arrivalString)
        print(json)
      #endif
      
      return determineNonZeroArrivalString(arrivalString: arrivalString)
    }
  }
  
  func backgroundColorForTime(_ time: Int) -> UIColor {
    let colorPalette = ColorPalette()
    
    switch(time) {
    case 0:
      // Blue
      return colorPalette.powderBlue()
    case 1...7:
      // Green
      return colorPalette.emeraldGreen()
    case 8...14:
      // Orange
      return colorPalette.creamsicleOrange()
    default:
      return colorPalette.lollipopRed()
    }
  }
  
  func determineNonZeroArrivalString(arrivalString: String) -> String {
    switch arrivalString {
    case NonNumericaArrivals.APPROACHING.rawValue:
      return "Arriving"
    case NonNumericaArrivals.DELAYED.rawValue:
      return "Delay"
    default:
      return "0"
    }
  }
}

/**
 Enum representing states of incoming buses that are less than 1 minute
 
 - APPROACHING: The `description` of the incoming bus is "APPROACHING"
 - DELAYED:     The `description` of the incoming bus is "DELAYED"
 */
public enum NonNumericaArrivals: String {
  case APPROACHING = "APPROACHING"
  case DELAYED = "DELAYED"
}

/**
 Checks the cases that are special for numeric arrivals
 
 - ARRIVED: When the `description` of the incoming bus is `0`
 */
public enum NumericArrivals: Int {
  case arrived = 0
}
