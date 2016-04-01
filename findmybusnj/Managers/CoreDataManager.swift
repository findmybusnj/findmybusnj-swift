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
  
  func sortDescending(array: [NSManagedObject]) -> [NSManagedObject]
}