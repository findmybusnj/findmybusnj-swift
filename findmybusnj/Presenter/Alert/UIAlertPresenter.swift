//
//  UIAlertPresenter.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/8/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit

/**
 Handles the types of alerts that can be generated
 
 - Empty_Search: Should be shown if search box is empty
 */
enum AlertWarning {
  case Empty_Search
}

class UIAlertPresenter {
  
  /**
   Used to present a UIAlertController for a given alert type
   
   - parameter type: An `AlertWarning` type that will be matched to generate an alert
   
   - returns: `UIAlertController` with pre formatted text and no handlers
   */
  func presentAlertWarning(type: AlertWarning) -> UIAlertController {
    switch type {
    case AlertWarning.Empty_Search:
      return empty_search()
    }
  }
  
  /**
   Creates a `UIAlertController` for the search box being empty
   
   - returns: `UIAlertController` that contains a "No stop entered" message and no handlers
   */
  private func empty_search() -> UIAlertController {
    let warning = UIAlertController(title: "No stop entered", message: "Please enter a stop before searching", preferredStyle: UIAlertControllerStyle.Alert)
    let doneButton = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil)
    warning.addAction(doneButton)
    return warning
  }
}
