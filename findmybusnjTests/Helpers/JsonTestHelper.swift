//
//  JsonTestHelper.swift
//  findmybusnj
//
//  Created by David Aghassi on 2/26/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import XCTest

// MARK: Dependancies
import SwiftyJSON

extension XCTestCase {
  /**
   Loads json from the json file in the test bundle and returns a `JSON` object from it
   
   - parameter fileName: The name of the file being searched for
   
   - returns: `JSON` object if the file is found, `nil` otherwise.
   */
  func loadJSONFromFile(fileName: String) -> JSON {
    var jsonData: NSData = NSData()
    
    #if DEBUG
    print(NSBundle(forClass: CardTimeTableControllerUnitTests.self).description)
    print(NSBundle(forClass: CardTimeTableControllerUnitTests.self).pathForResource(fileName, ofType: "json"))
    #endif
    
    let path = NSBundle(forClass: self.dynamicType).pathForResource(fileName, ofType: "json")
    XCTAssertNotNil(path, "Failed to get path to json file. Double check that the file is added to the test bundle.")
    
    do {
      // At this ponit we know it is safe to unwrap the path because we asserted prior
      try jsonData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe)
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }
    
    let responseJSON = JSON(data: jsonData)
    XCTAssertTrue(!responseJSON.isEmpty, "JSON should not be empty when loading JSON from file")
    
    return responseJSON
  }
}
