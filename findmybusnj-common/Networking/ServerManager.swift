//
//  ServerManager.swift
//  findmybusnj
//  Class for handling the server connections to retrieve new time data
//
//  Created by David Aghassi on 12/30/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation

// MARK: Dependencies
import Alamofire
import SwiftyJSON

/**
 Part of the `findmybusnj-common` framework. Used to make calls to findmybusnj.com server
 */
open class ServerManager: NSObject {
  fileprivate let baseURL = "https://findmybusnj.com/rest"
  fileprivate let manager = Alamofire.SessionManager.default
   var lastEndpoint = ""
   var url : String {
    return "\(baseURL)\(lastEndpoint)"
  }
  
  /**
   Get all the buses coming to a given stop. When using this, you need to pass a completion function in to handle the json returned by the server call.
   
   - Parameters:
     - stop: The six digit stop number that the user gets from myBus sign at stop
     - completion: A function to be called back upon success that takes a JSON array and any errors
   */
  open func getJSONForStop(_ stop: String, completion: @escaping (_ item: JSON, _ error: Error?) -> Void) {
    let parameters = [ "stop" : stop ]
    let endpoint = "/stop"
    makePOST(endpoint, parameters: parameters, completion: completion)
  }
  
  /**
   Get all the buses coming to a given stop, filtered by the bus number. So if the user passes in `165`, the buses returned will only be those that have `165` in the number scheme. This function requires a completion handler so that the json can be handled when called.
   
   - Parameters:
     - stop: The six digit string provided by the myBus stop sign that the user types in
     - route: The three digit string that defines the bus number/route to filter on
     - completion: A callback function to handle the JSON data upon a successful request
   */
  open func getJSONForStopFilteredByRoute(_ stop: String, route: String, completion: @escaping (_ item: JSON, _ error: Error?) -> Void) {
    let parameters = [ "stop" : stop, "route" : route]
    let endpoint = "/stop/byRoute"
    makePOST(endpoint, parameters: parameters, completion: completion);
  }
  
  /**
   Wrapper function around common `.POST` request call. Used for making post requests that take a string of parameters to go to an endpoint. This function requires a completion handler to handle the JSON once it responds successfully.
   
   - TODO: Better handle failure if JSON is not properly returned
   
   - Parameters:
     - endpoint: String that denotes the endpoint to hit when pinned to the `baseURL`
     - parameters: `[String : String]` of parameters that will be handled when the enpoint is hit
     - completion: The completion function that will be called when the data is succesfully returned
   */
  fileprivate func makePOST(_ endpoint: String, parameters: [String : String], completion: @escaping (_ item: JSON, _ error: Error?) -> Void) {
    let url = baseURL + endpoint
    lastEndpoint = endpoint
    manager.session.configuration.timeoutIntervalForRequest = 30
    
    manager.request(url, method: .post, parameters: parameters)
      .responseJSON { response in
        let json = response.result
        
        if (response.result.isFailure) {
          print("Error: \(json.error)")
        }
        else {
          // we know we can force case since it isn't a failure
          let json = JSON(json.value!)
          
          // call closure for what is past in (kind of like an anonymous function)
          completion(json, nil)
        }
    }
  }
}
