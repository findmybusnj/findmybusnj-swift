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

class ETABusTimeTableController: CardTableViewController {
  private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  private let alertPresenter = ETAAlertPresenter()
  
  // MARK: Properties
  var currentStop: String = ""
  var filterRoute: String = ""
  
  @IBOutlet weak var navigationBar: UINavigationItem!
  
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
      } catch {
        fatalError("Unable to save stop: \(error)")
      }
    }
    else {
      let warning = alertPresenter.presentAlertWarning(ETAAlertEnum.Empty_Stop)
      presentViewController(warning, animated: true, completion: nil)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  /**
   Refreshes the table given the `currentStop`
   
   - parameter sender: Object calling the refresh
   */
  override func refresh(sender: AnyObject) {
    if !filterRoute.isEmpty {
      NMServerManager.getJSONForStopFilteredByRoute(currentStop, route: filterRoute) {
        items, error in
        
        if error == nil {
          self.updateTable(items)
        }
      }
    }
    else if !currentStop.isEmpty {
      NMServerManager.getJSONForStop(currentStop) {
        items, error in
        
        if error == nil {
          self.updateTable(items)
        }
      }
    }
    else {
      self.refreshControl?.endRefreshing()
    }
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
      
      currentStop = stop
      navigationBar.title = stop
      
      if (route.isEmpty) {
        NMServerManager.getJSONForStop(stop) {
          items, error in
          
          if error == nil {
            self.updateTable(items)
          }
        }
      }
      else {
        filterRoute = route
        navigationBar.title = "\(stop) via \(route)"
        
        NMServerManager.getJSONForStopFilteredByRoute(stop, route: route) {
          items, error in
          
          if error == nil {
            self.updateTable(items)
          }
        }
      }
    }
    super.unwindToMain(sender)
  }
}
