//
//  FirstViewController.swift
//  findmybusnj
//
//  Created by David Aghassi on 9/28/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import UIKit

// MARK: Dependancies
import NetworkManager

class ETABusTimeTableController: CardTableViewController {
  // MARK: Properties
  var currentStop: String = ""
  var filterRoute: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  /**
   Refreshes the table given the `currentStop`
   -TODO: Handle error, refactor logic since it is the same callback for both
   
   - Parameter sender: Object calling the refresh
   */
  override func refresh(sender: AnyObject) {
    self.tableView.beginUpdates()
    
    if !filterRoute.isEmpty {
      NMServerManager.getJSONForStopFilteredByRoute(currentStop, route: filterRoute) {
        items, error in
        
        if error == nil {
          self.items = items
          self.tableView.reloadData()
          self.tableView.endUpdates()
          self.refreshControl?.endRefreshing()
        }
      }
    }
    else {
      NMServerManager.getJSONForStop(currentStop) {
        items, error in
        
        if error == nil {
          self.items = items
          self.tableView.reloadData()
          self.tableView.endUpdates()
          self.refreshControl?.endRefreshing()
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
      
      if (route.isEmpty) {
        currentStop = stop
        self.makeStopRequest(stop)
      }
      else {
        currentStop = stop
        filterRoute = route
        self.makeFilteredStopRequest(stop, route: route)
      }
      
    }
    super.unwindToMain(sender)
  }
  
  // MARK: Networking
  /**
    Called during the segue transition that will cause the table to make a request
    to the server for the given stop
  
    - TODO: abstract call backs, handle errors
    
    - Parameter stop: The stop number being requested from the server
   */
  private func makeStopRequest(stop: String) {
    NMServerManager.getJSONForStop(stop) {
      items, error in
      
      if error == nil {
        if items.rawString() == "No arrival times" {
          self.noPrediction = true
        }
        else {
          self.items = items
        }
        self.tableView.reloadData()
      }
    }
  }
  
  /**
   Called during the segue transition that will cause the table to make a request to the server
   for a given stop and route. The stops returned will be filtered by the 3 digit route provided.
   
   - TODO: abstract the callback to a function, handle error if not nil
   
   - Parameters:
      - stop: The stop number being requested from the server
      - route: The route to filter the buses by
   */
  private func makeFilteredStopRequest(stop: String, route: String) {
    NMServerManager.getJSONForStopFilteredByRoute(stop, route: route) {
      items, error in
      
      if error == nil {
        if items.rawString() == "No arrival times" {
          self.noPrediction = true
        }
        else {
          self.items = items
        }
        self.tableView.reloadData()
      }
    }
  }
}
