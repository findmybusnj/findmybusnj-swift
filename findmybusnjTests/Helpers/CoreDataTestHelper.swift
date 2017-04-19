//
//  CoreDataTestHelper.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/30/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import CoreData
@testable import findmybusnj

enum TestFavorite: String {
  case stop = "26229"
  case alternateStop = "13577"
  case route = "167"
  case emptyRoute = ""
}

/**
 Creates a temporary Managed Object Context.
 Idea originated from [Unit Testing Model Layer with Core Data and Swift](https://www.andrewcbancroft.com/2015/01/13/unit-testing-model-layer-core-data-swift/)
 
 - returns: A temporary managed object context in memory
 */
func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
  let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!

  let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

  do {
    try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                                      configurationName: nil, at: nil, options: nil)
  } catch {
    print("Adding in-memory persistent store coordinator failed")
  }

  let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

  return managedObjectContext
}

/**
 Generates a `Favorite` with only a `stop` value
 
 - parameter managedObjectContext: The object context that will have the items inserted.
 
 - returns: `Favorite` with only a `stop` value
 */
func generateFavorite(_ managedObjectContext: NSManagedObjectContext) -> Favorite {
  let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite",
                                                     into: managedObjectContext) as! Favorite
  favorite.stop = TestFavorite.stop.rawValue
  favorite.route = TestFavorite.emptyRoute.rawValue

  return favorite
}

/**
 Generates a new `Favorite` that contains a `route` value
 
 - parameter managedObjectContext: The object context that will have the items inserted.
 
 - returns: `Favorite` object with a `stop` and `route`.
 */
func generateFavoriteWithRoute(_ managedObjectContext: NSManagedObjectContext) -> Favorite {
  let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite",
                                                     into: managedObjectContext) as! Favorite
  favorite.stop = TestFavorite.stop.rawValue
  favorite.route = TestFavorite.route.rawValue

  return favorite
}

/**
 Generates a list of three `Favorite` managed objects that have a mix of stops and routes.
 
 - parameter managedObjectContext: The object context that will have the items inserted.
 
 - returns: An array of three `Favorite` objects
 */
func generateMultipleFavorites(_ managedObjectContext: NSManagedObjectContext) -> [Favorite] {
  let firstFavorite = generateFavorite(managedObjectContext)
  let secondFavorite = generateFavoriteWithRoute(managedObjectContext)
  secondFavorite.frequency = NSNumber(value: 2)
  let thirdFavorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite",
                                                          into: managedObjectContext) as! Favorite
  thirdFavorite.stop = TestFavorite.alternateStop.rawValue
  thirdFavorite.route = ""
  thirdFavorite.frequency = NSNumber(value: 3)

  let favorites = [firstFavorite, secondFavorite, thirdFavorite]
  return favorites
}
