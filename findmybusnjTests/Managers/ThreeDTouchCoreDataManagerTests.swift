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
  
  override func setUp() {
    super.setUp()
    
    managerUnderTest = ThreeDTouchCoreDataManager(managedObjectContext: managedObjectContext)
    XCTAssertNotNil(managedObjectContext, "Managed Object Context may not be nil when running these tests")
    UIApplication.sharedApplication().shortcutItems?.removeAll()
  }
  
  override func tearDown() {
    super.tearDown()
    
    managedObjectContext.deletedObjects
    do {
      try managedObjectContext.save()
    } catch {
      fatalError("Unable to save stop: \(error)")
    }
  }  
  
  /**
   `isDuplicate()` should never return true because it is unimplemented and set to return `false`
   */
  func test_Assert_isDuplicate_Always_False() {
    let fetch = NSFetchRequest(entityName: "Favorite")
    let predicate = NSPredicate(format: "stop == %@", "")
    let result = managerUnderTest.isDuplicate(fetch, predicate: predicate)
    XCTAssertFalse(result, "isDuplicate is unimplemented for 3D Touch Shortcuts, this should never return true")
  }
  
  /**
   `attemptToSave` should never return true because it is unimplemented and set to return `false`
   */
  func test_Assert_attemptToSave_Always_False() {
    let emptyManagedObject = generateFavorite(managedObjectContext)
    let result = managerUnderTest.attemptToSave(emptyManagedObject)
    XCTAssertFalse(result, "attemptToSave is unimplemented for 3D Touch Shortcuts, this should never return true")
  }
  
  // NOTE: `shortcutItems` in `UIApplication.sharedApplication()` is not the same when running tests as it is in your normal app. Hence, we don't have to mock here (though it would be nice)
  func test_Assert_updateShortcutItemsWithFavorites_For_Empty_List_Is_Empty() {
    let fetch = NSFetchRequest(entityName: "Favorite")
    do {
      let favorites = try managedObjectContext.executeFetchRequest(fetch) as! [NSManagedObject]
      managerUnderTest.updateShortcutItemsWithFavorites(favorites)
      let shortcutItems = UIApplication.sharedApplication().shortcutItems
      XCTAssertTrue(shortcutItems?.count == 0, "No shortcut items should exist. There were: \(shortcutItems?.count)")
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
      XCTAssertTrue(shortcutItems?.count == 1, "There should be one shorcut items, there were: \(shortcutItems?.count)")
      
      let shortcut = shortcutItems?[0]
      let type = "\(NSBundle.mainBundle().bundleIdentifier!).\(ShortcutIdentifier.findFavorite.rawValue)"
      
      guard let title = shortcutItems?[0].localizedTitle else {
        XCTFail("Title was nil when it shouldn't be for multiple favorites: \(#line)")
        return
      }
      guard let subtitle = shortcutItems?[0].localizedSubtitle else {
        XCTFail("Subtitle was nil when it shouldn't be for multiple favorites: \(#line)")
        return
      }
      
      XCTAssertTrue(favorite.stop == title, "Stop should be the same as the title of the shortcut. Title was: \(title). Should have been: \(favorite.stop!)")
      XCTAssertTrue(favorite.route == subtitle, "Route should be the same as the subtitle. Subtitle was: \(subtitle). Should have been: \(favorite.route!)")
      XCTAssertTrue(type == shortcut?.type, "Identifiers should match for given shortcut. See line: \(#line)")
      
    } catch {
      fatalError("Unable to fetch favorites for single favorite: \(error)")
    }
  }
  
  func test_Assert_updateShortcutItemsWithFavorites_For_Three_Favorites() {
    let favorites = generateMultipleFavorites(managedObjectContext)
    do {
      try managedObjectContext.save()
    } catch {
      fatalError("Unable to save multiple favorites for 3D Touch multiple favorite test: \(error)")
    }
    
    let fetch = NSFetchRequest(entityName: "Favorite")
    do {
      let fetchedFavorites = try managedObjectContext.executeFetchRequest(fetch) as! [NSManagedObject]
      XCTAssertTrue(fetchedFavorites.count == favorites.count, "There should be the same amount of favorites stored as there were fetched")
      
      managerUnderTest.updateShortcutItemsWithFavorites(fetchedFavorites)
      
      let type = "\(NSBundle.mainBundle().bundleIdentifier!).\(ShortcutIdentifier.findFavorite.rawValue)"
      let shortcutItems = UIApplication.sharedApplication().shortcutItems
      XCTAssertTrue(shortcutItems?.count == 3, "There should be three shorcut items, there were: \(shortcutItems?.count)")
      
      for index in (0...2) {
        guard let title = shortcutItems?[index].localizedTitle else {
          XCTFail("Title was nil when it shouldn't be for multiple favorites: \(#line)")
          return
        }
        guard let subtitle = shortcutItems?[index].localizedSubtitle else {
          XCTFail("Subtitle was nil when it shouldn't be for multiple favorites: \(#line)")
          return
        }
        let favorite = fetchedFavorites[index] as! Favorite
        
        XCTAssertTrue(title == favorite.stop, "Title should match stop number for favorite. Title was: \(title). Should have been: \(favorite.stop!)")
        XCTAssertTrue(subtitle == favorite.route, "Subtitle should match route for favorite. Subtitle was \(subtitle). Should have been: \(favorite.route!)")
        XCTAssertTrue(shortcutItems?[index].type == type, "Identifiers should match for given shorcut. See line: \(#line)")
      }
    } catch {
      fatalError("Unable to fetch favorites for multiple favorites: \(error)")
    }
  }
}
