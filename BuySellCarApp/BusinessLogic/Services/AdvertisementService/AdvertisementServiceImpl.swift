//
//  AdvertisementServiceImpl.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.03.2023.
//

import Foundation
import Combine

final class AdvertisementServiceImpl {
    // MARK: - Private properties
    private let advertisementNetworkService: AdvertisementNetworkService
    
    // MARK: - Init
    init(advertisementNetworkService: AdvertisementNetworkService) {
        self.advertisementNetworkService = advertisementNetworkService
    }
}

// MARK: - AdvertisementService
extension AdvertisementServiceImpl: AdvertisementService {
    func getAdvertisementCount(searchParams: [SearchParam]) -> AnyPublisher<Data, Error> {
        advertisementNetworkService.getAdvertisementCount(searchParams: searchParams)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func searchAdvertisement(searchParams: SearchResultDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error> {
        advertisementNetworkService.searchAdvertisement(searchParams: searchParams)
            .mapError { $0 as Error }
            .map { $0.map { AdvertisementDomainModel(advertisementResponseModel: $0) } }
            .eraseToAnyPublisher()
    }
}
