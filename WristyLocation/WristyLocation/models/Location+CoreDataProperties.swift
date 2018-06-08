//
//  Location+CoreDataProperties.swift
//  WristyLocation
//
//  Created by Pavan Kumar C on 08/06/18.
//  Copyright © 2018 pavan. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
    return NSFetchRequest<Location>(entityName: "Location")
  }
  
  @NSManaged public var title: String?
  @NSManaged public var coordinates: NSData?
  
}
