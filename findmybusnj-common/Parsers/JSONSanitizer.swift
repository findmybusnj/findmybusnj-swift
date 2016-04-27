//
//  JSONSanitizer.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/19/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit

// Dependancies
import SwiftyJSON

public class JSONSanitizer: NSObject {
  
  /**
   Returns the arrival time of the bus as a `String`
   
   - parameter json: `JSON` object containing `["pu"]`
   
   - returns: Arrival time as a `String`
   */
  public func getSanatizedArrivalTimeAsString(json: JSON) -> String {
    return json["pu"].description
  }
  
  /**
   Returns arrival time of a bus as an `Int`
   
   - parameter json: `JSON` object containing `["pt"]`
   
   - returns: Arrival time as an `Int`, '-1' if there isn't one
   */
  public func getSanitizedArrivaleTimeAsInt(json: JSON) -> Int {
    if let time = Int(json["pt"].description) {
      return time
    }
    else {
      return -1
    }
  }
  
  /**
   Returns the route number for the given json
   
   - parameter json: `JSON` object containing `["rd"]` subscript
   
   - returns: String with the three digit number for the route (e.g. `165`)
   */
  public func getSanitizedRouteNumber(json: JSON) -> String {
    return json["rd"].description
  }
  
  /**
   Sanitizes route data from JSON passed in
   
   - parameter json: JSON object containt `["fd"]` key for route
   
   - returns: The route sanitized to remove `&amp;`, as well as has each word capitalized at the start.
   */
  public func getSanitizedRouteDescription(json: JSON) -> String {
    var route = json["fd"].description
    route = route.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
    route = route.lowercaseString.capitalizedString
    return route
  }
}
