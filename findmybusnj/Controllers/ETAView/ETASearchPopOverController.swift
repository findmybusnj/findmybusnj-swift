//
//  ETAPopOverController.swift
//  findmybusnj
//
//  Created by David Aghassi on 1/18/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import Foundation
import UIKit

// MARK: Dependancies
import NetworkManager

class ETASearchPopOverController: UIViewController {
  @IBOutlet weak var stopNumberInput: UITextField!
  @IBOutlet weak var filterBusNumberInput: UITextField!
  @IBOutlet weak var favoritesTableView: UITableView!
  
  // MARK: Segue
  // Source of idea: http://jamesleist.com/ios-swift-tutorial-stop-segue-show-alert-text-box-empty/
  /**
  Overrides the `shouldPerformSegueWithIdentifier` method. Called before a segue is performed. Checks that if the segue identifier is `search`, and then checks whether or not the `stopNumberInput` is empty or not.
  
  - Parameters:
  - identifier: String identifier of the current segue trigger
  - sender: The object initiating the segue
  - return: A boolean that defines whether or not the segue should transition
  */
  override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
    if (identifier == "search") {
      let warn = UIAlertView(title: "No stop entered", message: "Please enter a stop before searching", delegate: nil, cancelButtonTitle: "Ok")
      
      // Check to see if user entered a stop number
      guard let stop = stopNumberInput.text else {
        warn.show()
        return false
      }
      if (stop.isEmpty) {
        warn.show()
        return false
      }
    }
    
    return true
  }
}

// MARK: UITextFieldDelegate
extension ETASearchPopOverController: UITextFieldDelegate {

  // Source of idea: http://stackoverflow.com/questions/433337/set-the-maximum-character-length-of-a-uitextfield?rq=1
  /**
  Regulates the `textField` to a certain range. `1` is the `filterBusNumberInput` field tag, and `0` is the `stopNumberInput` tag.
  */
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    // If the current character count is nil, we set it to zero using nil coelescing
    guard let textFieldText = textField.text else {
      return false
    }
    let currentCharCount = textFieldText.characters.count ?? 0;
    if (range.length + range.location > currentCharCount) {
      return false
    }
    let newLength = currentCharCount + string.characters.count - range.length
    
    // Stop textField
    if (textField.tag == 0) {
      return newLength <= 5
    }
      //Bus textField
    else if (textField.tag == 1) {
      return newLength <= 3
    }
    else {
      return false
    }
  }
  
  /**
   On hitting return, the current `textField` will resign the keyboard
   
   - parameter textField: The current `textField` that has triggered a return
   - return A boolean value if the `textField` should return or not.
   */
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
