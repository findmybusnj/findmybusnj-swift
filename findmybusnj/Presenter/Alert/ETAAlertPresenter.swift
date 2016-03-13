//
//  ETAAlertPresenter.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/13/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit

class ETAAlertPresenter: UIAlertPresenter {
  
  /**
   Used to present a UIAlertController for a given alert type. If no alert type matches, a new `UIAlertController` will be returned with empty `title` and `message, along with style of `Alert`
   
   - parameter type: An `ETAAlertEnum` type that will be matched to generate an alert
   
   - returns: `UIAlertController` with pre formatted text and no handlers
   */
  func presentAlertWarning(type: AlertEnum) -> UIAlertController {
    switch type {
    case ETAAlertEnum.Empty_Search:
      return empty_search()
    case ETAAlertEnum.Empty_Stop:
      return empty_stop()
    default:
      return UIAlertController(title: "", message: "", preferredStyle: .Alert)
    }
  }
  
  /**
   Creates a `UIAlertController` that wanrs the user if they are trying to save a stop without having searched for one.
   
   - returns: `UIAlertController` that contains a "No stop to save" message and no handlers
   */
  private func empty_stop() -> UIAlertController {
    let warning = createUIAlertControllerWithDoneButton()
    warning.title = "No stop to save"
    warning.message = "Please search for a bus stop before saving"
    return warning
  }
  
  /**
   Creates a `UIAlertController` for the search box being empty
   
   - returns: `UIAlertController` that contains a "No stop entered" message and no handlers
   */
  private func empty_search() -> UIAlertController {
    let warning = createUIAlertControllerWithDoneButton()
    warning.title = "No stop entered"
    warning.message = "Please enter a stop before searching"
    return warning
  }
}


extension UIAlertPresenter {
  /**
   Creates a `UIAlertController` with a `UIAlertAction` that says "Done". The controller has no `title` or `message`, and
   the `UIAlertAction` has no handler. All must be set separately if needed.
   
   - returns: A basic `UIAlertController` with a done button attached to it to dismiss it
   */
  private func createUIAlertControllerWithDoneButton() -> UIAlertController {
    let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
    let button = UIAlertAction(title: "Done", style: .Default, handler: nil)
    alert.addAction(button)
    return alert
  }
}