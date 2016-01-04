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
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "eta"

        let etaCard: ETACard = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ETACard
        
        formatCardForIndex(etaCard, index: indexPath)
        
        return etaCard
    }
    
    // Helper functions for assigning JSON Data
    
    private func formatCardForIndex(card: ETACard, index: NSIndexPath) {
        assignArrivalTimeForIndex(card, index: index.row)
    }
    
    private func assignArrivalTimeForIndex(card: ETACard, index: Int) {
        let arrivalString = self.items.arrayValue[index]["pu"].description
        if arrivalString == "MINUTES" {
            let time = self.items.arrayValue[index]["pt"].description
            card.timeLabel.text = time + " min."
        }
        else {
            print(self.items.arrayValue[index]["pu"].description)
            
            switch arrivalString {
                case "ARRIVING":
                    card.timeLabel.text = "Arriving"
                case "DELAYED":
                    card.timeLabel.text = "Delayed"
            default:
                card.timeLabel.text = "0"
            }
        }
    }
    
}