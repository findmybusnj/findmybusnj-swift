//
//  ServerManager.swift
//  findmybusnj
//  Class for handling the server connections to retrieve new time data
//
//  Created by David Aghassi on 12/30/15.
//  Copyright © 2015 David Aghassi. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

public class ServerManager {
    private static let baseURL = "https://localhost:8443/rest"
    
    public static func getJSONForStop(stop: String, completion: (item: JSON, error: ErrorType?) -> Void) {
        let endpoint = baseURL + "/stop"
        
        let headers = [ "stop" : stop ]
        Alamofire.request(.POST, endpoint, headers: headers)
            .responseJSON {(req, res, json) in
                if (json.isFailure) {
                    NSLog("Error: \(json.error)")
                }
                else {
                    let json = JSON(json.value!)
                    // call closure for what is past in (kind of like an anonymous function)
                    completion(item: json, error: nil);
                }
        }
    }
    
}