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

class BusTimeTableController: CardTableViewController {
    // MARK: Properties
    var currentStop: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     Refreshes the table given the `currentStop`
     
     - Parameter sender: Object calling the refresh
    */
    override func refresh(sender: AnyObject) {
        self.tableView.beginUpdates()
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
            let sourceController = sender.sourceViewController as! ETAPopOverController

            if let stop = sourceController.stopNumberInput.text {
                currentStop = stop
                self.makeStopRequest(stop)
            }
        }
        super.unwindToMain(sender)
    }
    
    // MARK: Networking
    
    /**
     Called during the segue transition that will cause the table to make a request
     to the server for the given stop
    
     - Parameters stop: The stop number we request from the server
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
}

