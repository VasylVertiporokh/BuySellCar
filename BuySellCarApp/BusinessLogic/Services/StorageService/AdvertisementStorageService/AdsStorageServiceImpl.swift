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
    
    // MARK: - Private properties
    private let stack: CoreDataStack
    
    // MARK: - Publishers
    private(set) lazy var favoriteAdsPublisher = favoriteAdsSubject.eraseToAnyPublisher()
    private let favoriteAdsSubject = CurrentValueSubject<[AdvertisementDomainModel], Never>([])
    
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
}

// MARK: - FavoriteAdsStorageService
extension AdsStorageServiceImpl: FavoriteAdsStorageService {
    func synchronizeFavoriteAds(adsDomainModel: [AdvertisementDomainModel]?) {
        let request: NSFetchRequest<FavoriteCoreDataModel> = FavoriteCoreDataModel.fetchRequest()
        let existingItems = try? stack.backgroundContext.fetch(request)
        
        guard let existingItems = existingItems,
              let adsDomainModel = adsDomainModel,
                !adsDomainModel.isEmpty else {
            favoriteAdsErrorSubject.send(AdsStorageError.defaultError)
            return
        }
        
        let items: [FavoriteCoreDataModel] = adsDomainModel.map {
            .init(
                adsDomainModel: $0,
                isFavorite: true,
                insertIntoManagedObjectContext: stack.backgroundContext
            )
        }
        
        // filtered item to delete
        let itemsToDelete = existingItems.filter { !items.contains($0) }
        itemsToDelete.forEach { stack.backgroundContext.delete($0) }
        
        // filtered item to save
        let itemsToInsert = items.filter { !existingItems.contains($0) }
        itemsToInsert.forEach { stack.backgroundContext.insert($0) }
        saveContext(contextType: .backgroundContext)
    }
    
    func fetchFavoriteAds() {
        let request: NSFetchRequest<FavoriteCoreDataModel> = FavoriteCoreDataModel.fetchRequest()
        do {
            let model = try stack.viewContext.fetch(request)
            favoriteAdsSubject.value = model.map { .init(dataBaseModel: $0) }
        } catch {
            favoriteAdsErrorSubject.send(AdsStorageError.fetchFavoriteError)
        }
    }
    
    func deleteFavoriteAds(adsDomainModel: AdvertisementDomainModel) {
        let item = FavoriteCoreDataModel(
            adsDomainModel: adsDomainModel,
            insertIntoManagedObjectContext: stack.backgroundContext
        )
        stack.backgroundContext.delete(item)
        saveContext(contextType: .backgroundContext)
    }
}
