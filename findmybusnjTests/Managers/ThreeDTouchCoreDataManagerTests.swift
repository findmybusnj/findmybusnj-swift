//
//  ThreeDTouchCoreDataManagerTests.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/3/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import XCTest
import CoreData
@testable import findmybusnj

class ThreeDTouchCoreDataManagerTests: XCTestCase {
  var managedObjectContext = setUpInMemoryManagedObjectContext()
  var managerUnderTest: ThreeDTouchCoreDataManager!
  var lastFavorite: Favorite?
  
  override func setUp() {
    super.setUp()
    
    managerUnderTest = ThreeDTouchCoreDataManager(managedObjectContext: managedObjectContext)
    XCTAssertNotNil(managedObjectContext, "Managed Object Context may not be nil when running these tests")
    UIApplication.sharedApplication().shortcutItems?.removeAll()
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
   `isDuplicate()` should never return true because it is unimplemented and set to return `false`
   */
  func test_Assert_isDuplicate_Always_False() {
    let emptyFetch = NSFetchRequest()
    let emptyPredicate = NSPredicate()
    let result = managerUnderTest.isDuplicate(emptyFetch, predicate: emptyPredicate)
    XCTAssertFalse(result, "isDuplicate is unimplemented for 3D Touch, this should never return true")
  }
  
  /**
   `attemptToSave` should never return true because it is unimplemented and set to return `false`
   */
  func test_Assert_attemptToSave_Always_False() {
    let emptyManagedObject = NSManagedObject()
    let result = managerUnderTest.attemptToSave(emptyManagedObject)
    XCTAssertFalse(result, "attemptToSave is unimplemented for 3D Touch, this should never return true")
  }
  
  // NOTE: `shortcutItems` in `UIApplication.sharedApplication()` is not the same when running tests as it is in your normal app. Hence, we don't have to mock here (though it would be nice)
  func test_Assert_updateShortcutItemsWithFavorites_For_Empty_List_Is_Empty() {
    let fetch = NSFetchRequest(entityName: "Favorite")
    do {
      let favorites = try managedObjectContext.executeFetchRequest(fetch) as! [NSManagedObject]
      managerUnderTest.updateShortcutItemsWithFavorites(favorites)
      let shortcutItems = UIApplication.sharedApplication().shortcutItems
      XCTAssertTrue(shortcutItems?.count == 0, "No shortcut items should exist")
    } catch {
      fatalError("Unable to fetch favorites: \(error)")
    }
  }
  
  func test_Assert_updateShortcutItemsWithFavorites_For_Single_Favorite() {
    let favorite = generateFavoriteWithRoute(managedObjectContext)
    do {
      try managedObjectContext.save()
    } catch {
      fatalError("Unable to save favorite for 3D Touch single favorite test: \(error)")
    }
    
    let fetch = NSFetchRequest(entityName: "Favorite")
    do {
      let favorites = try managedObjectContext.executeFetchRequest(fetch) as! [NSManagedObject]
      XCTAssertTrue(favorites.count > 0, "There should be NSManagedObjects to work with, can't create shortcut items without them")
      
      managerUnderTest.updateShortcutItemsWithFavorites(favorites)
      let shortcutItems = UIApplication.sharedApplication().shortcutItems
      XCTAssertTrue(shortcutItems?.count == 1, "No shortcut items should exist")
      
      let shortcut = shortcutItems?[0]
      let type = "\(NSBundle.mainBundle().bundleIdentifier!).\(ShortcutIdentifier.findFavorite.rawValue)"
      XCTAssertTrue(favorite.stop == shortcut?.localizedTitle, "Stop should be the same as the title of the shortcut")
      XCTAssertTrue(favorite.route == shortcut?.localizedSubtitle, "Route should be the same as the subtitle")
      XCTAssertTrue(type == shortcut?.type, "Identifiers should match for given shortcut.")
      
    } catch {
      fatalError("Unable to fetch favorites: \(error)")
    }
  }
  
  func test_Assert_updateShortcutItemsWithFavorites_For_Three_Favorites() {
    
  }
}
