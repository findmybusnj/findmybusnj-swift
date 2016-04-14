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

/// Base class of a `UITableViewController` that displays cards
// TODO - Make this into a protocol and extend it
class CardTableViewController: UITableViewController {
  // MARK: Properties
  // List of items we will populate the table with
  var items: JSON = []
  var noPrediction = false
  
  // MARK: Formatters
  private let etaCardPresenter = ETACardPresenter()
  
  // MARK: View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // setup the refresh controller for the table
    self.refreshControl = UIRefreshControl()
    self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh stops")
    self.refreshControl?.addTarget(self, action: #selector(CardTableViewController.refresh(_:)), forControlEvents: .ValueChanged)
    
    self.tableView.separatorColor = UIColor.clearColor()
    self.tableView.separatorStyle = .None
    self.tableView.backgroundColor = UIColor.lightGrayColor()
    
    // Prevents refresh controller from showing on emtpy list
    // Idea came from http://stackoverflow.com/questions/19243177/how-to-scroll-to-top-in-ios7-uitableview
    let top = tableView.contentInset.top
    self.tableView.contentOffset = CGPointMake(0, 0-top)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
   Updates the `tableView` given an array of JSON objects by calling `reloadData()`.
   Decidedes whether or not to show "No Current Predictions" label.
   
   - parameter json: The json returned from a network call to be added to the table
   */
  func updateTable(json: JSON) {
    if json.rawString() == "No arrival times" || json.isEmpty {
      self.noPrediction = true
    }
    else {
      self.noPrediction = false
      self.items = json
    }
    self.tableView.reloadData()
    self.refreshControl?.endRefreshing()
  }
  
  // MARK: UITableViewController
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if (!items.isEmpty || noPrediction) {
      tableView.backgroundView = nil
      return 1
    }
    else {
      // Idea taken from http://www.ryanwright.me/cookbook/ios/objc/uitableview/empy-table-message
      let emptyMessage = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
      
      emptyMessage.text = "Please tap on \"Find\" to get started"
      emptyMessage.textAlignment = .Center
      emptyMessage.textColor = UIColor.lightTextColor()
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
    let index = indexPath.row
    
    let etaCard: ETACard = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ETACard
    
    etaCard.removeCircleFromCard(etaCard)
    etaCard.clearText()
    
    if (noPrediction) {
      etaCard.noPrediction.hidden = false;
    }
    else {
      let json = items[index]
      etaCardPresenter.formatCardForPresentation(etaCard, json: json)
    }
    
    return etaCard
  }
}