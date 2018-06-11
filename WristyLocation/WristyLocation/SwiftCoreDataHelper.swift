//
//  SwiftCoreDataHelper.swift
//  WristyLocation
//
//  Created by Pavan Kumar C on 08/06/18.
//  Copyright © 2018 pavan. All rights reserved.
//

import UIKit
import CoreData

class SwiftCoreDataHelper: NSObject {

  class func sharedAppGroup() -> String {
    return "group.com.pavan.kumar.WristyLocation"
  }
  
  class func managedObjectModel() -> NSManagedObjectModel {
    let proxyBundle = Bundle(identifier: "com.pavan.kumar.WristyLocation")
    let modelURL = proxyBundle?.url(forResource: "WristyLocation", withExtension: "momd")
    return NSManagedObjectModel(contentsOf: modelURL!)!
  }
  
  class func persistantStoreCoordinator() -> NSPersistentStoreCoordinator? {
    let sharedContainerURL : URL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: SwiftCoreDataHelper.sharedAppGroup())
    
    if let sharedContainerURL = sharedContainerURL {
      let storeURL = sharedContainerURL.appendingPathComponent("database.sqlite")
      let coordinator = NSPersistentStoreCoordinator(managedObjectModel: SwiftCoreDataHelper.managedObjectModel())
      do {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
      } catch {
        // error
      }
      
      return coordinator
    }
    return nil
  }
  
  class func managedObjectContext() -> NSManagedObjectContext {
    let coordinator = SwiftCoreDataHelper.persistantStoreCoordinator()
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
  }
  
  class func insertManagedObjectContext(className: String, managedObjectContext: NSManagedObjectContext) -> AnyObject {
    let managedObject = NSEntityDescription.insertNewObject(forEntityName: className, into: managedObjectContext)
    return managedObject
  }
  
  class func saveManagedObjectContext(managedObjectContext: NSManagedObjectContext) -> Bool {
    try! managedObjectContext.save()
    return true
  }
  
  class func fetchEntities(className: String, predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?, managedObjectContext: NSManagedObjectContext) -> Array<Any> {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    let entityDescription = NSEntityDescription.entity(forEntityName: className, in: managedObjectContext)
    fetchRequest.entity = entityDescription
    
    if predicate != nil {
      fetchRequest.predicate = predicate!
    }
    
    if sortDescriptor != nil {
      fetchRequest.sortDescriptors = [sortDescriptor!]
    }
    
    fetchRequest.returnsObjectsAsFaults = false
    
    let items = try! managedObjectContext.fetch(fetchRequest)
    return items
  }
  
}
