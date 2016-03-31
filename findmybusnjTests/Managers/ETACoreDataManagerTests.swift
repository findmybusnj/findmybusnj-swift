//
//  ETACoreDataManager.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/30/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import XCTest
import CoreData
@testable import findmybusnj

class ETACoreDataManagerTests: XCTestCase {
  var managedObjectContext = setUpInMemoryManagedObjectContext()
  var managerUnderTest: ETACoreDataManager!
  var lastFavorite: Favorite?
  
  override func setUp() {
    super.setUp()
    
    managerUnderTest = ETACoreDataManager(context: managedObjectContext)
    XCTAssertNotNil(managedObjectContext, "Managed Object Context may not be nil when running these tests")
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    if let insertedObject = lastFavorite {
      managedObjectContext.deleteObject(insertedObject)
      do {
        try managedObjectContext.save()
      } catch {
        fatalError("Unable to save stop: \(error)")
      }
    }
  }
  
  /**
   Generates a `Favorite` with only a `stop` value
   
   - returns: `Favorite` with only a `stop` value
   */
  func generateFavorite() -> Favorite {
    let favorite = NSEntityDescription.insertNewObjectForEntityForName("Favorite", inManagedObjectContext: managedObjectContext) as! Favorite
    favorite.stop = TestFavorite.STOP.rawValue
    favorite.route = TestFavorite.EMPTY_ROUTE.rawValue
    lastFavorite = favorite
    
    return favorite
  }
  
  /**
   Generates a new `Favorite` that contains a `route` value
   
   - returns: `Favorite` object with a `stop` and `route`.
   */
  func generateFavoriteWithRoute() -> Favorite {
    let favorite = NSEntityDescription.insertNewObjectForEntityForName("Favorite", inManagedObjectContext: managedObjectContext) as! Favorite
    favorite.stop = TestFavorite.STOP.rawValue
    favorite.route = TestFavorite.ROUTE.rawValue
    lastFavorite = favorite
    
    return favorite
  }
 
  func test_Assert_attemptToSave_For_Stop_Returns_True() {
    let favorite = generateFavorite()
    let result = managerUnderTest.attemptToSave(favorite)
    XCTAssertTrue(result, "Core Data failed to save a new favorite with stop \(favorite.stop)")
  }
  
  func test_Assert_attemptToSave_For_Stop_And_Route_Returns_True() {
    let favorite = generateFavoriteWithRoute()
    let result = managerUnderTest.attemptToSave(favorite)
    XCTAssertTrue(result, "Core Data failed to save a new favorite with stop: \(favorite.stop) and route: \(favorite.route)")
  }
  
  func test_Assert_isDuplicate_Returns_True() {
    let favorite = generateFavoriteWithRoute()
    let result = managerUnderTest.attemptToSave(favorite)
    XCTAssertTrue(result, "Core Data failed to save a new favorite with stop: \(favorite.stop) and route: \(favorite.route)")
    
    let fetchRequest = NSFetchRequest(entityName: "Favorite")
    let predicate = NSPredicate(format: "stop == %@ AND route == %@", favorite.stop!, favorite.route!)
    
    let duplicate = managerUnderTest.isDuplicate(fetchRequest, predicate: predicate)
    XCTAssertTrue(duplicate, "Check should return true when a duplicate save is attempted")
  }
  
  func test_Assert_isDuplicate_Returns_False() {
    let fetchRequest = NSFetchRequest(entityName: "Favorite")
    let predicate = NSPredicate(format: "stop == %@ AND route == %@", TestFavorite.STOP.rawValue, TestFavorite.EMPTY_ROUTE.rawValue)
    
    let duplicate = managerUnderTest.isDuplicate(fetchRequest, predicate: predicate)
    XCTAssertFalse(duplicate, "Check should return false when a duplicate does not exist")
  }
}
