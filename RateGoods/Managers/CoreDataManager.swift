//
//  CoreDataManager.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/19/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let objectModelName = "Model"
    private let objectModelExtension = "momd"
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.objectModelName,
                                             withExtension: self.objectModelExtension) else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(self.objectModelName).sqlite"
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    private func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    
    func saveFavouriteGoods(with title: String, ref: String, image: Data?, rating: Float, reviews: Int16) {
        let entity = NSEntityDescription.entity(forEntityName: "GoodsCoreData",
                                             in: self.managedObjectContext)!
        
        let goodsCoreData = GoodsCoreData(entity: entity, insertInto: self.managedObjectContext)
        goodsCoreData.title = title
        goodsCoreData.ref = ref
        goodsCoreData.image = image
        goodsCoreData.rating = rating
        goodsCoreData.reviews = reviews
        
        self.saveContext()
    }
    
    func goodsIsExist(with ref: String) -> Bool {
        let goods = self.loadGoods()
        
        for item in goods where item.ref == ref {
            return true
        }
        
        return false
    }
    
    func loadGoods() -> [GoodsCoreData] {
        let fetchRequest = NSFetchRequest<GoodsCoreData>(entityName: "GoodsCoreData")
        var fetchResult = [GoodsCoreData]()
        do {
            fetchResult = try self.managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchResult
    }
    
    func deleteGoods(with ref: String) {
        let fetchRequest = NSFetchRequest<GoodsCoreData>(entityName: "GoodsCoreData")
        var fetchResults = [GoodsCoreData]()
        do {
            fetchResults = try managedObjectContext.fetch(fetchRequest)
            for result in fetchResults where result.ref == ref {
                managedObjectContext.delete(result)
            }
        } catch let error as NSError {
            print("Delete route by ref in GoodsCoreData error: \(error)")
        }
        self.saveContext()
    }
}
