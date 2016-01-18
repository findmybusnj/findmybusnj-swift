//
//  FirstViewController.swift
//  findmybusnj
//
//  Created by David Aghassi on 9/28/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import UIKit
import NetworkManager

class BusTimeTableController: CardTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NMServerManager.getJSONForStop("26229") {
            items, error in
            
            if error == nil {
                self.items = items
                self.tableView.reloadData()
            }
        }
    }
    
    override func refresh(sender: AnyObject) {
        self.tableView.beginUpdates()
        NMServerManager.getJSONForStop("26229") {
            items, error in
            
            if error == nil {
                self.items = items
                self.tableView.reloadData()
                self.tableView.endUpdates()
                self.refreshControl?.endRefreshing()
            }
        }
        self.tableView.endUpdates()
        self.refreshControl?.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

