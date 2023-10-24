//
//  AdsStorageServiceImpl.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 06/09/2023.
//

import Foundation
import CoreData
import Combine

final class AdsStorageServiceImpl {
    // MARK: - Internal properties
    var favoriteAds: [AdvertisementDomainModel] {
        favoriteAdsSubject.value
    }
    
    var ownAds: [AdvertisementDomainModel] {
        ownAdsSubject.value
    }
    
    // MARK: - Private properties
    private let stack: CoreDataStack
    
    // MARK: - Publishers
    private(set) lazy var favoriteAdsPublisher = favoriteAdsSubject.eraseToAnyPublisher()
    private let favoriteAdsSubject = CurrentValueSubject<[AdvertisementDomainModel], Never>([])
    
    private(set) lazy var ownAdsPublisher = ownAdsSubject.eraseToAnyPublisher()
    private let ownAdsSubject = CurrentValueSubject<[AdvertisementDomainModel], Never>([])
    
    private(set) lazy var favoriteAdsErrorPublisher = favoriteAdsErrorSubject.eraseToAnyPublisher()
    private let favoriteAdsErrorSubject = PassthroughSubject<Error, Never>()
    
    // MARK: - Init
    init(stack: CoreDataStack) {
        self.stack = stack
    }
}

// MARK: - AdsStorageService
extension AdsStorageServiceImpl: AdsStorageService {
    func saveContext(contextType: ContextType) {
        switch contextType {
        case .viewContext:
            guard stack.viewContext.hasChanges else { return }
            do {
                try stack.viewContext.save()
            } catch {
                favoriteAdsErrorSubject.send(AdsStorageError.saveError)
            }
            
        case .backgroundContext:
            guard stack.backgroundContext.hasChanges else { return }
            do {
                try stack.backgroundContext.save()
            } catch {
                favoriteAdsErrorSubject.send(AdsStorageError.saveError)
            }
        }
    }
    
    func fetchAdsByType(_ type: AdvertisementType) {
        let request: NSFetchRequest<AdsCoreDataModel> = AdsCoreDataModel.fetchRequest()
        request.predicate = NSPredicate(format: "\(type.filterParam) == %@", NSNumber (value: true))
        
        switch type {
        case .ownAds:
            do {
                let model = try stack.viewContext.fetch(request)
                ownAdsSubject.value = model.map { .init(dataBaseModel: $0) }
            } catch {
                favoriteAdsErrorSubject.send(AdsStorageError.fetchFavoriteError)
            }

        case .favoriteAds:
            do {
                let model = try stack.viewContext.fetch(request)
                favoriteAdsSubject.value = model.map { .init(dataBaseModel: $0) }
            } catch {
                favoriteAdsErrorSubject.send(AdsStorageError.fetchFavoriteError)
            }
        }
    }
    
    func synchronizeAdsByType(_ type: AdvertisementType, adsDomainModel: [AdvertisementDomainModel]?) {
        let request: NSFetchRequest<AdsCoreDataModel> = AdsCoreDataModel.fetchRequest()
        request.predicate = NSPredicate(format: "\(type.filterParam) == %@", NSNumber (value: true))
        
        let existingItems = try? stack.backgroundContext.fetch(request)
        var items = [AdsCoreDataModel]()
        
        guard let existingItems = existingItems,
              let adsDomainModel = adsDomainModel,
                !adsDomainModel.isEmpty else {
            favoriteAdsErrorSubject.send(AdsStorageError.defaultError)
            return
        }
        
        switch type {
        case .ownAds:
            items = adsDomainModel.map {
                .init(
                    adsDomainModel: $0,
                    isOwnAds: true,
                    insertIntoManagedObjectContext: stack.backgroundContext
                )
            }
        case .favoriteAds:
            items = adsDomainModel.map {
                .init(
                    adsDomainModel: $0,
                    isFavorite: true,
                    insertIntoManagedObjectContext: stack.backgroundContext
                )
            }
        }
        
        // filtered item to delete
        let itemsToDelete = existingItems.filter { !items.contains($0) }
        itemsToDelete.forEach { stack.backgroundContext.delete($0) }
        
        // filtered item to save
        let itemsToInsert = items.filter { !existingItems.contains($0) }
        itemsToInsert.forEach { stack.backgroundContext.insert($0) }
        saveContext(contextType: .backgroundContext)
    }
    
    func deleteAdsByType(_ type: AdvertisementType, adsDomainModel: AdvertisementDomainModel?) {
        // request for delete
        let request: NSFetchRequest<AdsCoreDataModel> = AdsCoreDataModel.fetchRequest()
        request.predicate = NSPredicate(format: "\(type.filterParam) == %@", NSNumber (value: true))
        
        // try get object for delete
        let objectToDelete = try? stack.backgroundContext.fetch(request)
            .first(where: { $0.objectId == adsDomainModel?.objectID })
        
        guard let object = objectToDelete else {
            return
        }

        // switch by types
        switch type {
        case .favoriteAds:
            stack.backgroundContext.delete(object)
        case .ownAds:
            stack.backgroundContext.delete(object)
        }
        
        // save changes
        saveContext(contextType: .backgroundContext)
    }
}
