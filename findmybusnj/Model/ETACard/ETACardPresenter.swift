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

// Handles laying out an `ETACard` for a `ETACardTableView`
class ETACardPresenter {
  
  /**
   Enum representing states of incoming buses that are less than 1 minute
   
   - APPROACHING: The `description` of the incoming bus is "APPROACHING"
   - DELAYED:     The `description` of the incoming bus is "DELAYED"
   */
  enum NonNumericaArrivals: String {
    case APPROACHING = "APPROACHING"
    case DELAYED = "DELAYED"
  }
  
  /**
   Checks the cases that are special for numeric arrivals
   
   - ARRIVED: When the `description` of the incoming bus is `0`
   */
  enum NumericArrivals: Int {
    case ARRIVED = 0
  }
  
  /**
   Formats the given `ETACard` for the `json` at the provided row
   
   - parameter card:  ETACard for the given reusable cell
   - parameter json:  json for the given row in the table
   */
  func formatCardForPresentation(card: ETACard, json: JSON) {
    assignArrivalTimeForJson(card, json: json)
    assignBusAndRouteTextForJson(card, json: json)
  }
  
  // MARK: Private functions
  /**
   Assigns the arrival time to the given card given the json at that index
   If the time is not a number, we assign it Arriving/Delayed/No Current Prediction
  
  - TODO: Refactor the render method to make it loosely coupled.
   
   - Parameters:
   - card:   The card in the tableview being edited
   - json:   The json at the current index.
   */
  private func assignArrivalTimeForJson(card: ETACard, json: JSON) {
    let arrivalString = json["pu"].description
    
    // Reset to black everytime just in case
    card.timeLabel.textColor = UIColor.blackColor()

    
    if let arrivalTime = Int(json["pt"].description) {
      if arrivalTime ==  NumericArrivals.ARRIVED.rawValue {
        card.timeLabel.text = "Arrive"
        card.timeLabel.textColor = UIColor.whiteColor()
        card.renderFilledCircleForBusTime(arrivalTime) // We know this will be 0 at this point
      }
      else {
        card.timeLabel.text = arrivalTime.description + " min."
        // We also render the circle here
        card.renderCircleForBusTime(arrivalTime)
      }
    }
    else {
      #if DEBUG
        print(json["pu"].description)
        print(json)
      #endif
      
      switch arrivalString {
      case NonNumericaArrivals.APPROACHING.rawValue:
        card.timeLabel.text = "Arrive"
        card.timeLabel.textColor = UIColor.whiteColor()
        card.renderFilledCircleForBusTime(0)
      case NonNumericaArrivals.DELAYED.rawValue:
        card.timeLabel.text = "Delay"
        card.timeLabel.textColor = UIColor.whiteColor()
        card.renderFilledCircleForBusTime(35)
      default:
        card.timeLabel.text = "0"
        card.timeLabel.textColor = UIColor.blueColor()
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
  private func assignBusAndRouteTextForJson(card: ETACard, json: JSON) {
    card.busNumberLabel.text = json["rd"].description
    
    var route = json["fd"].description
    route = route.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
    route = route.lowercaseString.capitalizedString
    
    card.routeLabel.text = route
    card.routeLabel.adjustsFontSizeToFitWidth = true
  }
}
