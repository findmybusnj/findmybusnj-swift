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
 
 - emptySearch: Should be shown if search box is empty
 - emptyStop:   Should be shown if there is no stop currently being searched for
 - duplicateStopSaved:   Should be shown if there is a stop already existing in Core Data
 */
enum ETAAlertEnum: AlertEnum {
  case emptySearch
  case emptyStop
  case duplicateStopSaved
}
