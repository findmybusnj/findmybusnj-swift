//
//  ShortcutIdentifier.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/31/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import Foundation

/**
 Shorcuts that can be selected by 3D Touch
 
 - OpenSearch: Will open the `ETASearchPopOverController` overlay
 - FindFavorite: Will perform a search and open to `ETABusTimeTableController`
 */
enum ShortcutIdentifier: String {
  case openSearch
  case findFavorite
  
  /**
   Initializes the identifier
   
   - parameter fullIdentifier: Identifier passed by `AppDelegate` upon 3D Touch
   
   - returns: The identifier or `nil`
   */
  init?(fullIdentifier: String) {
    guard let shortIdentifier = fullIdentifier.componentsSeparatedByString(".").last else {
      return nil
    }
    self.init(rawValue: shortIdentifier)
  }
}