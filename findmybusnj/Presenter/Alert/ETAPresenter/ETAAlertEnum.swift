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
 */
enum ETAAlertEnum: AlertEnum {
  case Empty_Search
  case Empty_Stop
}