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

    managerUnderTest = ETACoreDataManager(managedObjectContext: managedObjectContext)
    XCTAssertNotNil(managedObjectContext, "Managed Object Context may not be nil when running these tests")
  }

  override func tearDown() {
    super.tearDown()

    if let insertedObject = lastFavorite {
      managedObjectContext.delete(insertedObject)
      do {
        try managedObjectContext.save()
      } catch {
        fatalError("Unable to save stop: \(error)")
      }
    }
  }

  func test_Assert_attemptToSave_For_Stop_Returns_True() {
    let favorite = generateFavorite(managedObjectContext)
    lastFavorite = favorite
    let result = managerUnderTest.attemptToSave(favorite)
    XCTAssertTrue(result, "Core Data failed to save a new favorite with stop \(favorite.stop)")
  }

  func test_Assert_attemptToSave_For_Stop_And_Route_Returns_True() {
    let favorite = generateFavoriteWithRoute(managedObjectContext)
    lastFavorite = favorite
    let result = managerUnderTest.attemptToSave(favorite)
    XCTAssertTrue(result,
                  "Core Data failed to save a new favorite with stop:" +
                  " \(favorite.stop) and route: \(favorite.route)")
  }

  func test_Assert_isDuplicate_Returns_True() {
    let favorite = generateFavoriteWithRoute(managedObjectContext)
    lastFavorite = favorite
    let result = managerUnderTest.attemptToSave(favorite)
    XCTAssertTrue(result,
                  "Core Data failed to save a new favorite with stop:" +
                  " \(favorite.stop) and route: \(favorite.route)")

    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
    let predicate = NSPredicate(format: "stop == %@ AND route == %@", favorite.stop!, favorite.route!)

    let duplicate = managerUnderTest.isDuplicate(fetchRequest as! NSFetchRequest<NSManagedObject>, predicate: predicate)
    XCTAssertTrue(duplicate, "Check should return true when a duplicate save is attempted")
  }

  func test_Assert_isDuplicate_Returns_False() {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
    let predicate = NSPredicate(format: "stop == %@ AND route == %@",
                                TestFavorite.STOP.rawValue, TestFavorite.EMPTY_ROUTE.rawValue)

    let duplicate = managerUnderTest.isDuplicate(fetchRequest as! NSFetchRequest<NSManagedObject>, predicate: predicate)
    XCTAssertFalse(duplicate, "Check should return false when a duplicate does not exist")
  }
}
