//
//  Favorite+CoreDataProperties.swift
//  
//
//  Created by David Aghassi on 3/13/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Favorite {

    @NSManaged var route: String?
    @NSManaged var stop: String?
    @NSManaged var frequency: NSNumber?

}
