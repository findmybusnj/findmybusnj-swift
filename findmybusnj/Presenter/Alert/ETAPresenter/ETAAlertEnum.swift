//
//  ETAAlert_Enum.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/13/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import Foundation

/**
 Handles the types of alerts that can be generated
 
 - Empty_Search: Should be shown if search box is empty
 - Empty_Stop:   Should be shown if there is no stop currently being searched for
 - Stop_Saved:   Should be shown if there is a stop already existing in Core Data
 */
enum ETAAlertEnum: AlertEnum {
  case empty_Search
  case empty_Stop
  case duplicate_Stop_Saved
}
