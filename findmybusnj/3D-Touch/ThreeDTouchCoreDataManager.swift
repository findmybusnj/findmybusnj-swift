//
//  3DTouchCoreDataManager.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/1/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit
import CoreData
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/**
 *  Updates the ShortcutItems in the 3D Touch menu.
 */
struct ThreeDTouchCoreDataManager: CoreDataManager {
  var managedObjectContext: NSManagedObjectContext
  
  /**
   Always return `false`. This `struct` should never need to check if there is a duplicate in the store.
   
   - returns: False
   */
  func isDuplicate(_ fetchRequest: NSFetchRequest<AnyObject>, predicate: NSPredicate) -> Bool {
    return false
  }
  
  /**
   Always returns `false`. This `struct` should never attempt to save.
   
   - returns: False
   */
  func attemptToSave(_ managedObject: NSManagedObject) -> Bool {
    return false
  }
  
  /**
   Updates the top three favorites selectable by 3D Touch shortcut icons
   
   - parameter favorites: Array of `NSManagedObject` that will be force cast to `Favorite` to update the `shortcutItems`
   */
  func updateShortcutItemsWithFavorites(_ favorites: [NSManagedObject]) {
    var shortcutList = UIApplication.shared.shortcutItems
    var shortcutItem: UIApplicationShortcutItem
    
    // Start by removing anything we have
    if shortcutList?.count > 0  {
      UIApplication.shared.shortcutItems?.removeAll()
    }
    
    // Figure how far we have to travel
    var end: Int {
      if favorites.count >= 3 {
        return 2
      }
      else {
        // offset by one because this will be used as an index
        return favorites.count - 1
      }
    }
    
    if favorites.count > 0 {
      for i in (0...end).reversed() {
        let currentFavorite = favorites[i] as! Favorite
        
        guard let identifier = Bundle.main.bundleIdentifier else {
          return
        }
        guard let title = currentFavorite.stop else {
          return
        }
        guard let subtitle = currentFavorite.route else {
          return
        }
        
        // form type so we can react when pressed
        let shortcutID = ShortcutIdentifier.findFavorite.rawValue
        let type = "\(identifier).\(shortcutID)"
        
        // Certain icons are only available in iOS 9.3
        // NOTE - This isn't testable because you can't chekc the type of `UIApplicationShortcutIcon`
        if #available(iOS 9.1, *) {
          shortcutItem = UIApplicationShortcutItem(type: type, localizedTitle: title, localizedSubtitle: subtitle, icon: UIApplicationShortcutIcon(type: .favorite), userInfo: nil)
        } else {
          // Fallback on earlier versions
          shortcutItem = UIApplicationShortcutItem(type: type, localizedTitle: title, localizedSubtitle: subtitle, icon: UIApplicationShortcutIcon(type: .search), userInfo: nil)
        }
        
        UIApplication.shared.shortcutItems?.insert(shortcutItem, at: 0)
      }
    }
  }
}
