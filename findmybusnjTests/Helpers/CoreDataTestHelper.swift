//
//  CoreDataTestHelper.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/30/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import CoreData

enum TestFavorite: String {
  case STOP = "26229"
  case ROUTE = "167"
  case EMPTY_ROUTE = ""
}

/**
 Creates a temporary Managed Object Context.
 Idea originated from [Unit Testing Model Layer with Core Data and Swift](https://www.andrewcbancroft.com/2015/01/13/unit-testing-model-layer-core-data-swift/)
 
 - returns: A temporary managed object context in memory
 */
func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
  let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles([NSBundle.mainBundle()])!
  
  let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
  
  do {
    try persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
  } catch {
    print("Adding in-memory persistent store coordinator failed")
  }
  
  let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
  managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
  
  return managedObjectContext
}