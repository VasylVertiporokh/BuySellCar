//
//  FavoriteAdsStorageService.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 06/09/2023.
//

import Foundation
import Combine

enum AdvertisementType {
    case ownAds
    case favoriteAds
    
    var filterParam: String {
        switch self {
        case .ownAds:               return "isOwnAds"
        case .favoriteAds:          return "isFavorite"
        }
    }
}

// MARK: - AdsStorageService
protocol AdsStorageService {
    var favoriteAds: [AdvertisementDomainModel] { get }
    var favoriteAdsPublisher: AnyPublisher<[AdvertisementDomainModel], Never> { get }
    var favoriteAdsErrorPublisher: AnyPublisher<Error, Never> { get }
    var ownAds: [AdvertisementDomainModel] { get }
    var ownAdsPublisher: AnyPublisher<[AdvertisementDomainModel], Never> { get }
    
    func saveContext(contextType: ContextType)
    func fetchAdsByType(_ type: AdvertisementType)
    func synchronizeAdsByType(_ type: AdvertisementType, adsDomainModel: [AdvertisementDomainModel]?)
    func deleteAdsByType(_ type: AdvertisementType, adsDomainModel: AdvertisementDomainModel?)
}
