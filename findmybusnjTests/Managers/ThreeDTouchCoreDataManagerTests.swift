//
//  ThreeDTouchCoreDataManagerTests.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/3/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import XCTest
@testable import findmybusnj

class ThreeDTouchCoreDataManagerTests: XCTestCase {
  var managedObjectContext = setUpInMemoryManagedObjectContext()
  var managerUnderTest: ThreeDTouchCoreDataManager!
  var lastFavorite: Favorite?
  
  override func setUp() {
    super.setUp()
    
    managerUnderTest = ThreeDTouchCoreDataManager(managedObjectContext: managedObjectContext)
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
  
}
