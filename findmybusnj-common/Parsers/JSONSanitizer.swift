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

open class JSONSanitizer: NSObject {
  
  /**
   Returns the arrival time of the bus as a `String`
   
   - parameter json: `JSON` object containing `["pu"]`
   
   - returns: Arrival time as a `String`
   */
  open func getSanatizedArrivalTimeAsString(_ json: JSON) -> String {
    return json["pu"].description
  }
  
  /**
   Returns arrival time of a bus as an `Int`
   
   - parameter json: `JSON` object containing `["pt"]`
   
   - returns: Arrival time as an `Int`, '-1' if there isn't one
   */
  open func getSanitizedArrivaleTimeAsInt(_ json: JSON) -> Int {
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
  open func getSanitizedRouteNumber(_ json: JSON) -> String {
    return json["rd"].description
  }
  
  /**
   Sanitizes route data from JSON passed in
   
   - parameter json: JSON object containt `["fd"]` key for route
   
   - returns: The route sanitized to remove `&amp;`, as well as has each word capitalized at the start.
   */
  open func getSanitizedRouteDescription(_ json: JSON) -> String {
    var route = json["fd"].description
    route = route.replacingOccurrences(of: "&amp;", with: "&")
    route = route.lowercased().capitalized
    return route
  }
}
