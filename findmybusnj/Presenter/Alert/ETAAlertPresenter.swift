//
//  ETAAlertPresenter.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/13/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit

// MARK: Dependancies
import PKHUD

struct ETAAlertPresenter: UIAlertPresenter {

  /**
   Used to present a UIAlertController for a given alert type. 
   If no alert type matches, a new `UIAlertController` will be returned with empty `title` and `message,
   along with style of `Alert`
   
   - parameter type: An `ETAAlertEnum` type that will be matched to generate an alert
   
   - returns: `UIAlertController` with pre formatted text and no handlers
   */
  func presentAlertWarning(_ type: AlertEnum) -> UIAlertController {
    switch type {
    case ETAAlertEnum.emptySearch:
      return empty_search()
    case ETAAlertEnum.emptyStop:
      return empty_stop()
    case ETAAlertEnum.duplicateStopSaved:
      return duplicate_stop()
    default:
      return UIAlertController(title: "", message: "", preferredStyle: .alert)
    }
  }

  /**
   Displays a checkmark in a box to show success of an action
   
   - parameter view: View that will have the progress notification overlaying it
   - parameter title: Title of the view to be presented
   */
  func presentCheckmarkInView(_ view: UIView, title: String) {
    HUD.flash(.success, delay: 1.0)
  }

  /**
   Creates a `UIAlertController` that wanrs the user if they are trying to save a stop without having searched for one.
   
   - returns: `UIAlertController` that contains a "No stop to save" message and no handlers
   */
  fileprivate func empty_stop() -> UIAlertController {
    let warning = createUIAlertControllerWithDoneButton()
    warning.title = "No stop to save"
    warning.message = "Please search for a bus stop before saving"
    return warning
  }

  /**
   Creates a `UIAlertController` for the search box being empty
   
   - returns: `UIAlertController` that contains a "No stop entered" message and no handlers
   */
  fileprivate func empty_search() -> UIAlertController {
    let warning = createUIAlertControllerWithDoneButton()
    warning.title = "No stop entered"
    warning.message = "Please enter a stop before searching"
    return warning
  }

  /**
   Creates a `UIAlertController` for the stop already existing in `Core Data`
   
   - returns: `UIAlertController` that contains a "Stop already saved" message and no handlers
   */
  fileprivate func duplicate_stop() -> UIAlertController {
    let warning = createUIAlertControllerWithDoneButton()
    warning.title = "Stop already saved"
    warning.message = ""
    return warning
  }
}

extension UIAlertPresenter {
  /**
   Creates a `UIAlertController` with a `UIAlertAction` that says "Done".
   The controller has no `title` or `message`, and
   the `UIAlertAction` has no handler. All must be set separately if needed.
   
   - returns: A basic `UIAlertController` with a done button attached to it to dismiss it
   */
  fileprivate func createUIAlertControllerWithDoneButton() -> UIAlertController {
    let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    let button = UIAlertAction(title: "Done", style: .default, handler: nil)
    alert.addAction(button)
    return alert
  }
}
