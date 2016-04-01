//
//  3DTouchCoreDataManager.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/1/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import Foundation
import CoreData

/**
 *  Updates the ShortcutItems in the 3D Touch menu.
 */
struct ThreeDTouchCoreDataManager: CoreDataManager {
  var managedObjectContext: NSManagedObjectContext
  
  /**
   Always return `false`. This `struct` should never need to check if there is a duplicate in the store.
   
   - returns: False
   */
  func isDuplicate(fetchRequest: NSFetchRequest, predicate: NSPredicate) -> Bool {
    return false
  }
  
  /**
   Always returns `false`. This `struct` should never attempt to save.
   
   - returns: False
   */
  func attemptToSave(managedObject: NSManagedObject) -> Bool {
    return false
  }
}