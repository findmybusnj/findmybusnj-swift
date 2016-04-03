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
  func attemptFetch(fetchRequest: NSFetchRequest) -> [NSManagedObject]
}

extension CoreDataManager {
  /**
   Takes a fetch request and returns the fetched array, or an empty array if there is an error
   
   - parameter fetchRequest: Request specifiying entity type
   
   - returns: Array of `NSManagedObject`s
   */
  func attemptFetch(fetchRequest: NSFetchRequest) -> [NSManagedObject] {
    do {
      // Grab the favorites and order them based on frequency
      let results = try managedObjectContext.executeFetchRequest(fetchRequest)
      return results as! [NSManagedObject]
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
      return [NSManagedObject]()
    }
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