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
import NetworkManager
import MRProgress

class ETABusTimeTableController: CardTableViewController {
  private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  private let alertPresenter = ETAAlertPresenter()
  
  // MARK: Properties
  var currentStop: String = ""
  var filterRoute: String = ""
  var selectedFavorite = (stop: "", route: "")
  
  // MARK: Outlets
  @IBOutlet weak var navigationBar: UINavigationItem!
  
  // MARK: View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
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
      let managedObjectContext = appDelegate.managedObjectContext
      
      // Duplicate check
      let fetchRequest = NSFetchRequest(entityName: "Favorite")
      let predicate = NSPredicate(format: "stop == %@ AND route == %@", currentStop, filterRoute)
      fetchRequest.predicate = predicate
      
      do {
        let result = try managedObjectContext.executeFetchRequest(fetchRequest)
        let duplicate = result as! [NSManagedObject]
        if (duplicate.count > 0) {
          let warning = alertPresenter.presentAlertWarning(ETAAlertEnum.Stop_Saved)
          presentViewController(warning, animated: true, completion: nil)
          return
        }
      } catch {
        fatalError("Unable to check for duplicate stop: \(error)")
      }
      
      // Save otherwise
      let favorite = NSEntityDescription.insertNewObjectForEntityForName("Favorite", inManagedObjectContext: managedObjectContext) as! Favorite
      favorite.stop = currentStop
      favorite.route = filterRoute
      
      do {
        try managedObjectContext.save()
        alertPresenter.presentCheckmarkInView(self.tableView, title: "Saved Favorite")
      } catch {
        fatalError("Unable to save stop: \(error)")
      }
    }
    else {
      let warning = alertPresenter.presentAlertWarning(ETAAlertEnum.Empty_Stop)
      presentViewController(warning, animated: true, completion: nil)
    }
  }
  
   /**
   Loads the selected favorite from the `ETASearchPopOverController`
   
   - parameter sender: Storyboard segue exiting to unwind back to this controller
   */
  @IBAction func loadSelectedFavorite(sender: UIStoryboardSegue) {
    if sender.identifier == "loadSelectedFavorite" {
      performSearch(selectedFavorite.stop, route: selectedFavorite.route)
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
  
  /**
   Returns the popover back to this controller. Called when a modal or popover is dimissed.
   If the button pressed to dismiss was "Search", we handle the data being passed so we can
   use the new stop to make a request to the server and update the table
   
   - Parameter sender: The `UIStoryboardSegue` being dismissed
   */
  override func unwindToMain(sender: UIStoryboardSegue) {
    // Make sure that we transfer data from the popover controller if user is searching
    if sender.identifier == "search" {
      let sourceController = sender.sourceViewController as! ETASearchPopOverController
      
      guard let stop = sourceController.stopNumberTextField.text else {
        return
      }
      guard let route = sourceController.filterRouteNumberTextField.text else {
        return
      }
      
      performSearch(stop, route: route)
    }
    super.unwindToMain(sender)
  }
  
  // MARK: Methods
  /**
   Does the network search based on the search and route pass in. Sets the `navigationBar.title` to the stop (including route if one is passed in).
   
   - parameter stop:  Required, sent to endpoint to return next busses
   - parameter route: Optional, filters buses on the stop
   */
  func performSearch(stop: String, route: String) {
    currentStop = stop
    filterRoute = route
    navigationBar.title = stop
    
    if currentStop.isEmpty {
      return
    }
    
    MRProgressOverlayView.showOverlayAddedTo(tableView, animated: true)
    if route.isEmpty {
      NMServerManager.getJSONForStop(stop) {
        [unowned self] items, error in
        
        if error == nil {
          self.updateTable(items)
          MRProgressOverlayView.dismissOverlayForView(self.tableView, animated: true)
        }
      }
    }
    else {
      navigationBar.title = "\(stop) via \(route)"
    
      NMServerManager.getJSONForStopFilteredByRoute(stop, route: route) {
        [unowned self] items, error in
        
        if error == nil {
          self.updateTable(items)
          MRProgressOverlayView.dismissOverlayForView(self.tableView, animated: true)
        }
      }
    }
  }
}
