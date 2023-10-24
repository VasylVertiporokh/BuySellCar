//
//  CoreDataStack.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 04/09/2023.
//

import Foundation
import CoreData

enum ContextType {
    case viewContext
    case backgroundContext
}

enum DataModelName: String {
    case mainModel = "BuySellCarModel"
}

final class CoreDataStack {
    // MARK: - Internal properties
    private(set) var dataModelName: String
    
    // MARK: - Init
    init(dataModelName: DataModelName) {
        self.dataModelName = dataModelName.rawValue
    }
    
    // MARK: - Properties
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(
            forResource: dataModelName,
            withExtension: "momd"
        )
        
        guard let modelURL = modelURL,
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Find or Load Data Model")
        }

        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(
            managedObjectModel: self.managedObjectModel
        )

        let storeName = "\(dataModelName).sqlite"
        let documentsDirectoryURL = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask
        ).first!
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: persistentStoreURL,
                options: nil
            )
            
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    private(set) lazy var viewContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    private(set) lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
}
