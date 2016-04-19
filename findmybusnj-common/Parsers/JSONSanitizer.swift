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
   Sanitizes route data from JSON passed in
   
   - parameter json: JSON object containt `["fd"]` key for route
   
   - returns: The route sanitized to remove `&amp;`, as well as has each word capitalized at the start.
   */
  public func getSanitizedRoute(json: JSON) -> String {
    var route = json["fd"].description
    route = route.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
    route = route.lowercaseString.capitalizedString
    return route
  }
}
