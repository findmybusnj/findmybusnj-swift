//
//  CardTableViewController.swift
//  findmybusnj
//
//  Created by David Aghassi on 10/23/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation
import UIKit

// MARK: Dependancies
import SwiftyJSON

class CardTableViewController: UITableViewController {
  // MARK: Properties
  // List of items we will populate the table with
  var items: JSON = []
  var noPrediction = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // setup the refresh controller for the table
    self.refreshControl = UIRefreshControl()
    self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh stops")
    self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    
    self.tableView.separatorColor = UIColor.clearColor()
    self.tableView.separatorStyle = .None
    
    // Prevents refresh controller from showing on emtpy list
    // Idea came from http://stackoverflow.com/questions/19243177/how-to-scroll-to-top-in-ios7-uitableview
    let top = tableView.contentInset.top
    self.tableView.contentOffset = CGPointMake(0, 0 - top)
  }
  
  /**
   Function called when `tableview` is pulled down to refresh data. Overridden in sub-class if need be
   
   - Parameter sender: The object calling the refresh
   */
  func refresh(sender: AnyObject) {
    // Overridden in sub-classes
    // This model was taken from http://stackoverflow.com/questions/24475792/how-to-use-pull-to-refresh-in-swift/24476087#24476087
  }
  
  /**
   Used to dismiss a popover view back to the root parent
   
   - parameter sender: The sender calling the function. Used to set the view to `sourceViewConroller`
   */
  @IBAction func unwindToMain(sender: UIStoryboardSegue) {
    _ = sender.sourceViewController
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: UITableViewController
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if (!items.isEmpty) {
      tableView.backgroundView = nil
      return 1
    }
    else {
      // Idea taken from http://www.ryanwright.me/cookbook/ios/objc/uitableview/empy-table-message
      let emptyMessage = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
      
      emptyMessage.text = "Please tap on \"Find\" to get started"
      emptyMessage.textAlignment = .Center
      emptyMessage.textColor = UIColor.grayColor()
      emptyMessage.sizeToFit()
      
      tableView.backgroundView = emptyMessage
      return 0
    }
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (noPrediction) {
      return 1;
    }
    noPrediction = false
    return self.items.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let identifier = "eta"
    
    let etaCard: ETACard = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ETACard
    
    etaCard.removeCircleFromCard(etaCard)
    etaCard.clearText()
    
    if (noPrediction) {
      etaCard.noPrediction.hidden = false;
    }
    else {
      formatCardForIndex(etaCard, index: indexPath)
    }
    
    return etaCard
  }
  
  
  // MARK: Private functions
  
  /**
  Formats table cell card with data from the JSON recieved from the `.POST` request
  
  - Parameters:
    - card: The card cell that we will be modifying
    - index: The index in the table that we are dealing with
  */
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
    let arrivalString = jsonValueForIndexAndSubscript(index, string: "pu")
    
    // Reset to black everytime just in case
    card.timeLabel.textColor = UIColor.blackColor()
    
    // We get the time from the JSON object
    if let time = Int(jsonValueForIndexAndSubscript(index, string: "pt")) {
      // special case where some JSON can be 0 minutes, hence is arriving
      if time == 0 {
        card.timeLabel.text = "Arrive"
        card.timeLabel.textColor = UIColor.whiteColor()
        card.renderFilledCircleForBusTime(time)
      }
      else {
        card.timeLabel.text = time.description + " min."
        
        // We also render the circle here
        card.renderCircleForBusTime(time)
      }
    }
    else {
      #if DEBUG
        print(self.items.arrayValue[index]["pu"].description)
        print(self.items.arrayValue[index])
      #endif
      
      // TODO - Make these into an Enum
      switch arrivalString {
      case "APPROACHING":
        card.timeLabel.text = "Arrive"
        card.timeLabel.textColor = UIColor.whiteColor()
        card.renderFilledCircleForBusTime(0)
      case "DELAYED":
        card.timeLabel.text = "Delay"
        card.timeLabel.textColor = UIColor.whiteColor()
        card.renderFilledCircleForBusTime(35)
      default:
        card.timeLabel.text = "0"
        card.timeLabel.textColor = UIColor.blueColor()
      }
    }
  }
  
  /**
   Assigns the bus number (e.g. `165`) to `busNumberLabel`, and assigns the
   route (e.g. `165 via NJ Turnpike`) to `route`.
   
   - Parameters:
     - card: The custom table view card we are modifying the values of
     - index: The index of the table view cell we are handling
   */
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