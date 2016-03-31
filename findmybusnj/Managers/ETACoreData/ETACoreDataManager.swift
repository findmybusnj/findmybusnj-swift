//
//  ETACoreDataManager.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/30/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit
import CoreData

struct ETACoreDataManager: CoreDataManager {
  var managedObjectContext: NSManagedObjectContext
  
  /**
   Creates a new `ETACoreDataManager` using the given object context
   
   - parameter context: The managed object context to be used by the manager
   
   - returns: A new `ETACoreDataManager`
   */
  init(context: NSManagedObjectContext) {
    managedObjectContext = context
  }
  
  /**
   Checks if the fetch request already exists in the `managedObjectContext`
   
   - parameter fetchRequest: Fetch request to execute
   - parameter predicate:    to be appened to the `predicate` of the request
   
   - returns: True if the request does exist, false otherwise
   */
  func isDuplicate(fetchRequest: NSFetchRequest, predicate: NSPredicate) -> Bool {
    // Duplicate check
    fetchRequest.predicate = predicate
    
    do {
      let result = try managedObjectContext.executeFetchRequest(fetchRequest)
      let duplicate = result as! [NSManagedObject]
      return duplicate.count > 0
    } catch {
      fatalError("Unable to check for duplicate stop: \(error)")
    }
  }
  
  /**
   Attempts to save the managed object to Core Data
   
   - parameter managedObject: object for which we are attempting to save
   
   - returns: True if the save is successful, `fatalError` otherwise
   */
  func attemptToSave(managedObject: NSManagedObject) -> Bool {    
    do {
      try managedObjectContext.save()
      return true
    } catch {
      fatalError("Unable to save stop: \(error)")
    }
  }
}