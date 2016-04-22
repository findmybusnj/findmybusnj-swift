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
  func formatCellForPresentation(cell: UITableViewCell, json: JSON)
  func assignArrivalTimeForJson(cell: UITableViewCell, json: JSON)
  func assignBusAndRouteTextForJson(cell: UITableViewCell, json: JSON)
}

public extension ETAPresenter {
  func backgroundColorForTime(time: Int) -> UIColor {
    let colorPallette = ColorPallette()
    
    if (time == 0) {
      // Blue
      return colorPallette.powderBlue()
    }
    else if (time <= 7) {
      // Green
      return colorPallette.emeraldGreen()
    }
    else if ( time <= 14) {
      // Orange
      return colorPallette.creamsicleOrange()
    }
    else {
      // Red
      return colorPallette.lollipopRed()
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
  case ARRIVED = 0
}