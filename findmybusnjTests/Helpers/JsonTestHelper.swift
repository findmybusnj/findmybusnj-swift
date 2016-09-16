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
  func loadJSONFromFile(_ fileName: String) -> JSON {
    var jsonData: Data = Data()
    
    let path = Bundle(forClass: type(of: self)).pathForResource(fileName, ofType: "json")
    XCTAssertNotNil(path, "Failed to get path to json file. Double check that the file is added to the test bundle.")
    
    do {
      // At this point we know it is safe to unwrap the path because we asserted prior
      try jsonData = Data(contentsOfFile: path!, options: .DataReadingMappedIfSafe)
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }
    
    let responseJSON = JSON(data: jsonData)
    return responseJSON
  }
}

enum JSONFileName: String {
  case singleStop = "singleStop"
  case stopWithAmpersand = "singleStopWithAmpersand"
  case noPrediction = "noPrediction"
}
