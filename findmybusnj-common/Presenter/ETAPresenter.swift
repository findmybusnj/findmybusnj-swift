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
  /**
   Based on the json provided, uses the `JSONSanitizer` to check the 
   `arrivalTime` (an `int`) and the `arrivalString` (a `string` representation of the time).
 
   If we are dealing with `arrivalTime`, we determine if the bus has `"Arrived"`
   (meaning it is 0), otherwise we know that it is still coming and return `"Minutes"`.
   If we don't have an `arrivalTime` (-1), then we determine if the bus is 
   `"Arriving"` or `"Delayed"` using `determineNonZeroArrivalString`
 
  - parameter json: A `JSON` object that is returned from the server to be parsed
  - returns: A `String` that is either "Arrived", "Minutes", "Arriving", or "Delayed"
 */
  func determineArrivalCase(json: JSON) -> String {
    let arrivalString = sanitizer.getSanatizedArrivalTimeAsString(json)
    let arrivalTime = sanitizer.getSanitizedArrivaleTimeAsInt(json)

    if arrivalTime != -1 {
      if arrivalTime ==  NumericArrivals.arrived.rawValue {
        return "Arrived"
      } else {
        return "Minutes"
      }
    } else {
      #if DEBUG
        print(arrivalString)
        print(json)
      #endif

      return determineNonZeroArrivalString(arrivalString: arrivalString)
    }
  }

  /**
   Determines the background color to be displayed in the cell given the time. 
 
   Cases: 
    - 0: `powderBlue`
    - 1...7: `emeraldGreen`
    - 8...14: `creamsicleOrange`
    - X > 14: `lollipopRed`
 
   See `ColorPalette` for the above colors.
 
   - returns: Any of the above colors depending on the case.
  */
  func backgroundColorForTime(_ time: Int) -> UIColor {
    let colorPalette = ColorPalette()

    switch time {
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

  /**
   Used to determine the type of string to be displayed if the incoming buses
   provided via the `JSON` response are `"Arriving"` or `"Delayed"`.
 
   - parameter arrivalString: Passed by `determineArrivalCase`. 
   Compared to `NonNumericalArrivals` enum to determine if `"Arriving"` or `"Delayed"`
   - returns: A string of `"Arriving"` or `"Delayed"`. If neither, returns "0".
 */
  func determineNonZeroArrivalString(arrivalString: String) -> String {
    switch arrivalString {
    case NonNumericArrivals.APPROACHING.rawValue:
      return "Arriving"
    case NonNumericArrivals.DELAYED.rawValue:
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
public enum NonNumericArrivals: String {
  case APPROACHING
  case DELAYED
}

/**
 Checks the cases that are special for numeric arrivals
 
 - ARRIVED: When the `description` of the incoming bus is `0`
 */
public enum NumericArrivals: Int {
  case arrived = 0
}
