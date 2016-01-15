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
        
        etaCard.removeCircleFromCard(etaCard)
        formatCardForIndex(etaCard, index: indexPath)
        
        return etaCard
    }
    
    // Helper functions for assigning JSON Data
    
    private func formatCardForIndex(card: ETACard, index: NSIndexPath) {
        assignArrivalTimeForIndex(card, index: index.row)
        assignBusAndRouteTextForIndex(card, index: index.row)
    }
    
    /**
     Assigns the arrival time to the given card given the index
     If the time is not a number, we assign it Arriving/Delayed/No Current Prediction
    
     - Parameters: 
        - card:   The card in the tableview being edited
        - index:  The current index in the tableview
    */
    private func assignArrivalTimeForIndex(card: ETACard, index: Int) {
        let arrivalString = self.items.arrayValue[index]["pu"].description
        
        // Reset to black everytime just in case
        card.timeLabel.textColor = UIColor.blackColor()
        
        if arrivalString == "MINUTES" {
            let time = self.items.arrayValue[index]["pt"].description
            card.timeLabel.text = time + " min."
            
            // We also render the circle here
            card.renderCircleForBusTime(Int(time)!)
        }
        else {
            print(self.items.arrayValue[index]["pu"].description)
            
            switch arrivalString {
                case "APPROACHING":
                    card.timeLabel.text = "Arrive"
                    card.timeLabel.textColor = UIColor.blueColor()
                case "DELAYED":
                    card.timeLabel.text = "Delay"
                    card.timeLabel.textColor = UIColor.redColor()
                    card.renderCircleForBusTime(35)
            default:
                card.timeLabel.text = "0"
                card.timeLabel.textColor = UIColor.blueColor()
            }
        }
    }
    
    private func assignBusAndRouteTextForIndex(card: ETACard, index: Int) {
        card.busNumberLabel.text = jsonValueForIndexAndSubscript(index, string: "rd")
        
        var route = jsonValueForIndexAndSubscript(index, string: "fd")
        route = route.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
        route = route.lowercaseString.capitalizedString
        
        card.routeLabel.text = route
        card.routeLabel.adjustsFontSizeToFitWidth = true
    }
    
    /**
     Gets the JSON value at the given index for the given subscript

     - Parameters:
        - index: The index in the array that the value exists at
        - string: The name of the substring for the value we want
     
     - Returns: String value stored at the index for the given subscript
    */
    private func jsonValueForIndexAndSubscript(index: Int, string: String) -> String {
        return self.items.arrayValue[index][string].description;
    }
}