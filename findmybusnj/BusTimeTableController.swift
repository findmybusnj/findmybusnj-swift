//
//  FirstViewController.swift
//  findmybusnj
//
//  Created by David Aghassi on 9/28/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import UIKit

// MARK: Frameworks
import NetworkManager

class BusTimeTableController: CardTableViewController {
    var currentStop: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
//        NMServerManager.getJSONForStop("26229") {
//            items, error in
//            
//            if error == nil {
//                if items.rawString() == "No arrival times" {
//                    self.noPrediction = true
//                }
//                else {
//                    self.items = items
//                }
//                self.tableView.reloadData()
//            }
//        }
    }
    
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
    
    override func unwindToMain(sender: UIStoryboardSegue) {
        // Make sure that we transfer data from the popover controller if user is searching
        if sender.identifier == "search" {
            let sourceController = sender.sourceViewController as! ETAPopOverController
            let warn = UIAlertView(title: "No stop entered", message: "Please enter a stop before hitting search", delegate: nil, cancelButtonTitle: "Ok")
            
            guard let stop = sourceController.stopNumberInput.text else {
                warn.show()
                return
            }
            if stop.isEmpty {
                warn.show()
            }
            else {
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
    func makeStopRequest(stop: String) {
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

