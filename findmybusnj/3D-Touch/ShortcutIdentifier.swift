//
//  ShortcutIdentifier.swift
//  findmybusnj
//
//  Created by David Aghassi on 3/31/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import Foundation

/**
 Idea originated form these sources:
 - http://iostuts.io/2015/10/08/how-to-add-quick-actions/
 - http://useyourloaf.com/blog/adding-3d-touch-quick-actions/
 */

/**
 Shorcuts that can be selected by 3D Touch
 
 - openSearch: Will open the `ETASearchPopOverController` overlay
 - findFavorite: Will perform a search and open to `ETABusTimeTableController`
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
    guard let shortIdentifier = fullIdentifier.components(separatedBy: ".").last else {
      return nil
    }
    self.init(rawValue: shortIdentifier)
  }
}
