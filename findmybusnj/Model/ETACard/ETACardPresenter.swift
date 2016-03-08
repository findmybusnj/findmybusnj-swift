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

/**
 Enum representing states of incoming buses that are less than 1 minute
 
 - APPROACHING: The `description` of the incoming bus is "APPROACHING"
 - ARRIVED:     The `description` of the incoming bus is "0" but isn't reporting as "APPROACHING" yet from NJT
 - DELAYED:     The `description` of the incoming bus is "DELAYED"
 */
enum NonNumericaArrivals: String {
  case APPROACHING = "APPROACHING"
  case ARRIVED = "0"
  case DELAYED = "DELAYED"
}

// Handles laying out an `ETACard` for a `ETACardTableView`
class ETACardPresenter {
  
  /**
   Formats the given `ETACard` for the `json` at the provided row
   
   - parameter card:  ETACard for the given reusable cell
   - parameter json:  json for the given row in the table
   
   - returns: A formatted `ETACard` for the given data
   */
  func formatCardForJson(card: ETACard, json: JSON) -> ETACard {
    
    
    return card
  }
  
  // MARK: Private functions
  /**
   Assigns the arrival time to the given card given the index
   If the time is not a number, we assign it Arriving/Delayed/No Current Prediction
   
   - Parameters:
   - card:   The card in the tableview being edited
   - index:  The current index in the tableview
   */
  private func assignArrivalTimeForJson(card: ETACard, json: JSON) {
//    let arrivalString = jsonValueForIndexAndSubscript(index, string: "pu")
    let arrivalString = json["pu"].description
    let time = json["pt"].description
    
    if time == NonNumericaArrivals.ARRIVED.rawValue {
      
    }
    
    // Reset to black everytime just in case
    card.timeLabel.textColor = UIColor.blackColor()
    
    // We get the time from the JSON object
    if let time = Int(jsonValueForIndexAndSubscript(index, string: "pt")) {
      // special case where some JSON can be 0 minutes, hence is arriving
      if time == 0 {
        card.timeLabel.text = "Arrive"
        card.timeLabel.textColor = UIColor.whiteColor()
        card.renderFilledCircleForBusTime(time)
      }
      else {
        card.timeLabel.text = time.description + " min."
        
        // We also render the circle here
        card.renderCircleForBusTime(time)
      }
    }
    else {
      #if DEBUG
        print(self.items.arrayValue[index]["pu"].description)
        print(self.items.arrayValue[index])
      #endif
      
      // TODO - Make these into an Enum
      switch arrivalString {
      case "APPROACHING":
        card.timeLabel.text = "Arrive"
        card.timeLabel.textColor = UIColor.whiteColor()
        card.renderFilledCircleForBusTime(0)
      case "DELAYED":
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
   - index: The index of the table view cell we are handling
   */
  private func assignBusAndRouteTextForIndex(card: ETACard, index: Int) {
    card.busNumberLabel.text = jsonValueForIndexAndSubscript(index, string: "rd")
    
    var route = jsonValueForIndexAndSubscript(index, string: "fd")
    route = route.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
    route = route.lowercaseString.capitalizedString
    
    card.routeLabel.text = route
    card.routeLabel.adjustsFontSizeToFitWidth = true
  }
  
  /**
   Gets the JSON value at the given index for the given subscript
   
   - Parameters:
   - index: The index in the array that the value exists at
   - string: The name of the substring for the value we want
   
   - Returns: String value stored at the index for the given subscript
   */
  private func jsonValueForIndexAndSubscript(index: Int, string: String) -> String {
    return self.items.arrayValue[index][string].description;
  }

}
