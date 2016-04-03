//
//  3DTouchCoreDataManager.swift
//  findmybusnj
//
//  Created by David Aghassi on 4/1/16.
//  Copyright © 2016 David Aghassi. All rights reserved.
//

import UIKit
import CoreData

/**
 *  Updates the ShortcutItems in the 3D Touch menu.
 */
struct ThreeDTouchCoreDataManager: CoreDataManager {
  var managedObjectContext: NSManagedObjectContext
  
  /**
   Always return `false`. This `struct` should never need to check if there is a duplicate in the store.
   
   - returns: False
   */
  func isDuplicate(fetchRequest: NSFetchRequest, predicate: NSPredicate) -> Bool {
    return false
  }
  
  /**
   Always returns `false`. This `struct` should never attempt to save.
   
   - returns: False
   */
  func attemptToSave(managedObject: NSManagedObject) -> Bool {
    return false
  }
  
  /**
   Updates the top three favorites selectable by 3D Touch shortcut icons
   
   - parameter favorites: Array of `NSManagedObject` that will be force cast to `Favorite` to update the `shortcutItems`
   */
  func updateShortcutItemsWithFavorites(favorites: [NSManagedObject]) {
    var shortcutList = UIApplication.sharedApplication().shortcutItems
    var shortcutItem: UIApplicationShortcutItem
    
    // Start by removing anything we have
    if shortcutList?.count > 0  {
      UIApplication.sharedApplication().shortcutItems?.removeAll()
    }
    
    // Figure how far we have to travel
    var end: Int {
      if favorites.count >= 3 {
        return 3
      }
      else {
        // offset by one because this will be used as an index
        return favorites.count - 1
      }
    }
    
    if favorites.count > 0 {
      for i in (0...end).reverse() {
        let currentFavorite = favorites[i] as! Favorite
        
        guard let identifier = NSBundle.mainBundle().bundleIdentifier else {
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
        if #available(iOS 9.1, *) {
          shortcutItem = UIApplicationShortcutItem(type: type, localizedTitle: title, localizedSubtitle: subtitle, icon: UIApplicationShortcutIcon(type: .Favorite), userInfo: nil)
        } else {
          // Fallback on earlier versions
          shortcutItem = UIApplicationShortcutItem(type: type, localizedTitle: title, localizedSubtitle: subtitle, icon: UIApplicationShortcutIcon(type: .Search), userInfo: nil)
        }
        
        UIApplication.sharedApplication().shortcutItems?.insert(shortcutItem, atIndex: 0)
      }
    }
  }
}