//
//  ETAFavoritesTableViewController.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/14/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit
import CoreData

class ETAFavoritesTableViewController: UITableViewController {
  private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  private let alertPresenter = ETAAlertPresenter()
  
  private var favorites = [NSManagedObject]()
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Get the MoC and create the fetch request
    let managedObjectContext = appDelegate.managedObjectContext
    let fetchRequest = NSFetchRequest(entityName: "Favorite")
    
    //3
    do {
      let results = try managedObjectContext.executeFetchRequest(fetchRequest)
      favorites = results as! [NSManagedObject]
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
  }
  
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("FavCell")
    let index = indexPath.row
    
    let favItem = favorites[index] as! Favorite
    
    cell?.textLabel?.text = favItem.stop
    
    return cell!
  }
  
}