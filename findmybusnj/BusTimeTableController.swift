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
        ServerManager.getJSONForStop("26229") {
            items, error in
            
            if error == nil {
                print(items)
                self.items = items
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

