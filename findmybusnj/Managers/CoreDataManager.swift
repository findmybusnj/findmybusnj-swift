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
  func isDuplicate(fetchRequest: NSFetchRequest, predicate: NSPredicate) -> Bool
  func attemptToSave(managedObject: NSManagedObject) -> Bool
}