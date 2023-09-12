//
//  FavoriteAdsStorageService.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 06/09/2023.
//

import Foundation
import Combine

protocol AdsStorageService {
    func saveContext(contextType: ContextType)
}

protocol FavoriteAdsStorageService {
    var favoriteAds: [AdvertisementDomainModel] { get }
    var favoriteAdsPublisher: AnyPublisher<[AdvertisementDomainModel], Never> { get }
    var favoriteAdsErrorPublisher: AnyPublisher<Error, Never> { get }
    
    func synchronizeFavoriteAds(adsDomainModel: [AdvertisementDomainModel]?)
    func fetchFavoriteAds()
    func deleteFavoriteAds(adsDomainModel: AdvertisementDomainModel)
}
