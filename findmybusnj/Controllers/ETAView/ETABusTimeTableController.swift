//
//  ETABusTimeTableController.swift
//  findmybusnj
//
//  Created by David Aghassi on 9/28/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import UIKit
import CoreData

// MARK: Dependancies
import findmybusnj_common
import PKHUD

class ETABusTimeTableController: CardTableViewController {
  private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  private let alertPresenter = ETAAlertPresenter()
  private var coreDataManager: ETACoreDataManager!
  private let networkManager = ServerManager()
  
  // MARK: Properties
  var currentStop: String = ""
  var filterRoute: String = ""
  var selectedFavorite = (stop: "", route: "")
  
  // MARK: Outlets
  @IBOutlet weak var navigationBar: UINavigationItem!
  
  // MARK: View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    coreDataManager = ETACoreDataManager(managedObjectContext: appDelegate.managedObjectContext)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: Actions
  /**
   Saves the `currentStop` to Core Data. If `filterRoute` is not empty, it is also saved.
   Items saved are done so in a `Favorite` class, which is a subclass of `NSManagedObject`.
   
   If there is no stop to save, the user is presented with a warning.
   
   - parameter sender: The bar button being pressed
   */
  @IBAction func saveFavorite(sender: UIButton) {
    if !currentStop.isEmpty {
      saveToFavorite()
    }
    else {
      let warning = alertPresenter.presentAlertWarning(ETAAlertEnum.Empty_Stop)
      presentViewController(warning, animated: true, completion: nil)
    }
  }
  
  /**
   Takes the current search information and performs a search on it. Information is passed from `ETASearchPopOverController`
   
   - parameter segue: Segue being performed
   */
  @IBAction func searchForStop(segue: UIStoryboardSegue) {
    if segue.identifier == "search" {
      let sourceController = segue.sourceViewController as! ETASearchPopOverController
      
      guard let stop = sourceController.stopNumberTextField.text else {
        return
      }
      guard let route = sourceController.filterRouteNumberTextField.text else {
        return
      }
      
      performSearch(stop, route: route)
    }
    else if segue.identifier == "loadSelectedFavorite" {
      performSearch(selectedFavorite.stop, route: selectedFavorite.route)
    }
    
    updateAppGroupData()
  }
  
  /**
   Dismisses a popover and unwinds back to this view controller
   
   - parameter segue: A segue with the identifier `exit`
   */
  @IBAction func dismissPopover(segue: UIStoryboardSegue) {
    if segue.identifier == "exit" {
     self.unwindForSegue(segue, towardsViewController: self)
    }
  }
  
  /**
   Refreshes the table given the `currentStop`
   
   - parameter sender: Object calling the refresh
   */
  override func refresh(sender: AnyObject) {
    performSearch(currentStop, route: filterRoute)
    self.refreshControl?.endRefreshing()
  }
  
  // MARK: Public Methods
  /**
   Handles when a `UIApplicationShortcutItem` is pressed via 3D Touch. This will perform a search for the favorite being selected.
   
   - parameter shortcut: The shortcut being pressed
   */
  func handleShortcut(shortcut: UIApplicationShortcutItem) {
    currentStop = shortcut.localizedTitle
    if let route = shortcut.localizedSubtitle {
      filterRoute = route
    }
    
    performSearch(currentStop, route: filterRoute)
  }
  
  /**
   Handles background fetches by system. Updates the table with any new data
   
   - parameter completionHandler: To be called when the data is fetched or failed to fetch
   */
  func updateInBackground(completionHandler: (UIBackgroundFetchResult) -> Void) {
    performSearchInBackground(completionHandler)
  }
  
  // MARK: Private Methods
  /**
   Does the network search based on the search and route pass in. Sets the `navigationBar.title` to the stop (including route if one is passed in).
   
   - parameter stop:  Required, sent to endpoint to return next busses
   - parameter route: Optional, filters buses on the stop
   */
  private func performSearch(stop: String, route: String) {
    currentStop = stop
    filterRoute = route
    navigationBar.title = stop
    
    if currentStop.isEmpty {
      return
    }
    
    HUD.show(.Progress)
    if route.isEmpty {
      networkManager.getJSONForStop(stop) {
        [unowned self] items, error in
        
        if error == nil {
          self.updateTable(items)
          HUD.hide()
        }
      }
    }
    else {
      navigationBar.title = "\(stop) via \(route)"
    
      networkManager.getJSONForStopFilteredByRoute(stop, route: route) {
        [unowned self] items, error in
        
        if error == nil {
          self.updateTable(items)
          HUD.hide()
        }
      }
    }
  }
  
  /**
   Modified version of `performSearch` that is only called when backgrounded.
   TODO: Refactor this into the normal `performSearch` method.
   
   - parameter completionHandler: `UIBackgroundFetchResult` function to be called after data is successfully fetched or not
   */
  private func performSearchInBackground(completionHandler: (UIBackgroundFetchResult) -> Void) {
    if (currentStop.isEmpty) {
      return
    }
    
    if (filterRoute.isEmpty) {
      networkManager.getJSONForStop(currentStop, completion: {
        [unowned self] items, error in
        
        if error == nil {
          self.updateTable(items)
          completionHandler(.NewData)
        }
        else if (error != nil) {
          completionHandler(.Failed)
        }
      })
    }
    else {
      navigationBar.title = "\(currentStop) via \(filterRoute)"
      
      networkManager.getJSONForStopFilteredByRoute(currentStop, route: filterRoute) {
        [unowned self] items, error in
        
        if error == nil {
          self.updateTable(items)
          completionHandler(.NewData)
        }
        else if (error != nil) {
          completionHandler(.Failed)
        }
      }

    }
  }
  
  /**
   Called when a user attempts to save a stop
   */
  private func saveToFavorite() {
    let managedObjectContext = appDelegate.managedObjectContext
    
    // Check for duplicates
    let fetchRequest = NSFetchRequest(entityName: "Favorite")
    let predicate = NSPredicate(format: "stop == %@ AND route == %@", currentStop, filterRoute)
    
    if coreDataManager.isDuplicate(fetchRequest, predicate: predicate) {
      let warning = alertPresenter.presentAlertWarning(ETAAlertEnum.Duplicate_Stop_Saved)
      presentViewController(warning, animated: true, completion: nil)
      return
    }
    
    // Save otherwise
    let favorite = NSEntityDescription.insertNewObjectForEntityForName("Favorite", inManagedObjectContext: managedObjectContext) as! Favorite
    favorite.stop = currentStop
    favorite.route = filterRoute
    
    if coreDataManager.attemptToSave(favorite) {
      alertPresenter.presentCheckmarkInView(self.tableView, title: "Saved Favorite")
    }
  }
  
  /**
   Called when a new stop is selected. Passes information to the `AppGroup` so the widget can perform updates
   independantly on load.
   */
  private func updateAppGroupData() {
    if let appGroup = NSUserDefaults.init(suiteName: "group.aghassi.TodayExtensionSharingDefaults") {
      appGroup.setObject(currentStop, forKey: "currentStop")
      appGroup.setObject(filterRoute, forKey: "filterRoute")
    }
  }
}
