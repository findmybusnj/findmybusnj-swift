//
//  CoreDataManager.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/30/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManager {
  var managedObjectContext: NSManagedObjectContext { get set }
  
  func isDuplicate(fetchRequest: NSFetchRequest, predicate: NSPredicate) -> Bool
  func attemptToSave(managedObject: NSManagedObject) -> Bool
}

extension CoreDataManager {
  /**
   Creates a new `ETACoreDataManager` using the given object context
   
   - parameter context: The managed object context to be used by the manager
   
   - returns: A new `ETACoreDataManager`
   */
  init(context: NSManagedObjectContext) {
    self.init(context: context)
    managedObjectContext = context
  }
  
  /**
   Takes an array of `Favorites` and sorts them descending based on the `frequency` of each item in the list
   
   - parameter array: Array consisting of `Favorites`
   
   - returns: A `Favorite` array sorted in descending order based on `frequency`
   */
  func sortDescending(array: [NSManagedObject]) -> [NSManagedObject] {
    let sortedDescending = array.sort({ (favoriteOne: NSManagedObject, favoriteTwo: NSManagedObject) -> Bool in
      guard let freqOne = (favoriteOne as! Favorite).frequency else {
        return false
      }
      guard let freqTwo = (favoriteTwo as! Favorite).frequency else {
        return false
      }
      
      return freqOne.intValue > freqTwo.intValue
    })
    
    return sortedDescending
  }
}