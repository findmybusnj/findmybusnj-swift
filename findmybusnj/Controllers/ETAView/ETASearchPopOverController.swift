//
//  ETAPopOverController.swift
//  findmybusnj
//
//  Created by David Aghassi on 1/18/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ETASearchPopOverController: UIViewController {
  fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate
  fileprivate var managedObjectContext: NSManagedObjectContext!
  fileprivate var coreDataManager: CoreDataManager!
  fileprivate var selectedFavorite = (stop: "", route: "")

  // MARK: Formatters
  fileprivate let alertPresenter = ETAAlertPresenter()

  // MARK: DataSource
  fileprivate var favorites = [NSManagedObject]()

  // MARK: Outlets
  @IBOutlet weak var stopNumberTextField: UITextField!
  @IBOutlet weak var filterRouteNumberTextField: UITextField!
  @IBOutlet weak var favoritesTableView: UITableView!

  // MARK: View Controller Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    managedObjectContext = appDelegate.managedObjectContext
    coreDataManager = ETACoreDataManager(managedObjectContext: managedObjectContext)
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")

    favorites = coreDataManager.attemptFetch(fetchRequest)
    favorites = coreDataManager.sortDescending(favorites)
  }

  // MARK: Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "loadSelectedFavorite" {
      let destinationViewController = segue.destination as! ETABusTimeTableController
      destinationViewController.selectedFavorite = self.selectedFavorite
    }
  }

  // Source of idea: http://jamesleist.com/ios-swift-tutorial-stop-segue-show-alert-text-box-empty/
  /**
  Overrides the `shouldPerformSegueWithIdentifier` method. 
   Called before a segue is performed. 
   Checks that if the segue identifier is `search`, and then checks whether or not
   the `stopNumberInput` is empty or not.
  
  - Parameters:
    - identifier: String identifier of the current segue trigger
    - sender: The object initiating the segue
  - return: A boolean that defines whether or not the segue should transition
  */
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if identifier == "search" {

      // Check to see if user entered a stop number
      guard let stop = stopNumberTextField.text else {
        showEmptyWarning()
        return false
      }
      if stop.isEmpty {
        showEmptyWarning()
        return false
      }
    }

    return true
  }

  /**
   Creates a UIAlertController to notify the user they have not entered the proper stop information
   */
  fileprivate func showEmptyWarning() {
    let warning = alertPresenter.presentAlertWarning(ETAAlertEnum.emptySearch)
    present(warning, animated: true, completion: nil)
  }
}

// MARK: UITextFieldDelegate
extension ETASearchPopOverController: UITextFieldDelegate {

  // Source of idea: http://stackoverflow.com/questions/433337/set-the-maximum-character-length-of-a-uitextfield?rq=1
  /**
  Regulates the `textField` to a certain range. `1` is the `filterBusNumberInput` field tag,
   and `0` is the `stopNumberInput` tag.
  */
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    // If the current character count is nil, we set it to zero using nil coelescing
    guard let textFieldText = textField.text else {
      return false
    }

    let currentCharCount = textFieldText.characters.count
    if range.length + range.location > currentCharCount {
      return false
    }
    let newLength = currentCharCount + string.characters.count - range.length

    if textField.tag == 0 { // Stop textField
      return newLength <= 5
    } else if textField.tag == 1 { // Route textField
      return newLength <= 3
    } else {
      return false
    }
  }

  /**
   On hitting return, the current `textField` will resign the keyboard
   
   - parameter textField: The current `textField` that has triggered a return
   - return A boolean value if the `textField` should return or not.
   */
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

// MARK: UITableViewDelegate
extension ETASearchPopOverController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let index = (indexPath as NSIndexPath).row

    let deleteAction = UITableViewRowAction(style: .default,
                                            title: "Delete",
                                            handler: { (_, _) -> Void in
      // Remove from table and core data
      let favoriteToDelete = self.favorites.remove(at: index)
      self.managedObjectContext.delete(favoriteToDelete)

      do {
        try self.managedObjectContext.save()
        self.favoritesTableView.reloadData()
      } catch let error as NSError {
        print("Could not save: \(error), \(error.userInfo)")
      }
    })

    deleteAction.backgroundColor = UIColor.red
    return [deleteAction]
  }
}

// MARK: UITableViewDataSource
extension ETASearchPopOverController: UITableViewDataSource {
  @objc(tableView:canEditRowAtIndexPath:) func tableView(_ tableView: UITableView,
                                                         canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell")!
    let index = (indexPath as NSIndexPath).row

    let favItem = favorites[index] as! Favorite

    guard let stop = favItem.stop else {
      cell.textLabel?.text = " "
      return cell
    }
    cell.textLabel?.text = "Stop: \(stop)"

    guard let route = favItem.route else {
      cell.detailTextLabel?.text = ""
      return cell
    }
    if !route.isEmpty {
      cell.detailTextLabel?.text = "Route: \(route)"
    } else {
      cell.detailTextLabel?.text = ""
    }

    return cell
  }

  @objc(tableView:willSelectRowAtIndexPath:) func tableView(_ tableView: UITableView,
                                                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    let index = (indexPath as NSIndexPath).row
    let selectedItem = favorites[index] as! Favorite

    guard let stop = selectedItem.stop else {
      return indexPath
    }

    guard let route = selectedItem.route else {
      return indexPath
    }

    guard let frequency = selectedItem.frequency else {
      return indexPath
    }

    // If nothing else, these should always be ""
    selectedFavorite.stop = stop
    selectedFavorite.route = route

    // Attempt to save the new selection to Core Data
    selectedItem.frequency! = NSNumber(value: frequency.intValue + 1 as Int32)
    coreDataManager.attemptToSave(selectedItem)

    return indexPath
  }
}
