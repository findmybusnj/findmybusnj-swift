//
//  ETAAlertPresenter.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/13/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit

// MARK: Dependancies
import MRProgress

struct ETAAlertPresenter: UIAlertPresenter {
  
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
    case ETAAlertEnum.Duplicate_Stop_Saved:
      return duplicate_stop()
    default:
      return UIAlertController(title: "", message: "", preferredStyle: .Alert)
    }
  }
  
  /**
   Displays a checkmark in a box to show success of an action
   
   - parameter view: View that will have the progress notification overlaying it
   - parameter title: Title of the view to be presented
   */
  func presentCheckmarkInView(view: UIView, title: String) {
    MRProgressOverlayView.showOverlayAddedTo(view, title: title, mode: MRProgressOverlayViewMode.Checkmark, animated: true)
    runAfterDelay(1.0, block: {
      MRProgressOverlayView.dismissOverlayForView(view, animated: true)
    })
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
  
  /**
   Creates a `UIAlertController` for the stop already existing in `Core Data`
   
   - returns: `UIAlertController` that contains a "Stop already saved" message and no handlers
   */
  private func duplicate_stop() -> UIAlertController {
    let warning = createUIAlertControllerWithDoneButton()
    warning.title = "Stop already saved"
    warning.message = ""
    return warning
  }
  
  /**
   Creates a timeout function to run a callback after a certain period of time
   Courtesy of [Hacking The Swift](https://www.hackingwithswift.com/example-code/system/how-to-run-code-after-a-delay-using-dispatch_after-and-performselector)
   
   - parameter delay: How long, in seconds, the timeout will be
   - parameter block: The callback that will be called after the allotted time
   */
  private func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(time, dispatch_get_main_queue(), block)
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