//
//  CardTableViewController.swift
//  findmybusnj
//
//  Created by David Aghassi on 10/23/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class CardTableViewController: UITableViewController {
    var items: JSON = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.separatorStyle = .None
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "eta"
        
        let etaCard: ETACard = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ETACard

        return etaCard
    }
    
}