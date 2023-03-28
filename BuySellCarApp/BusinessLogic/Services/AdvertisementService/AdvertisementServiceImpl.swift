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

extension AdvertisementServiceImpl: AdvertisementService {
    func getAdvertisementObjects(pageSize: String) -> AnyPublisher<[AdvertisementResponseModel], NetworkError> {
        advertisementNetworkService.getAdvertisementObjects(pageSize: pageSize)
    }
    
    func searchAdvertisement(searchParams: [SearchParam]) -> AnyPublisher<[AdvertisementResponseModel], NetworkError> {
        advertisementNetworkService.searchAdvertisement(searchParams: searchParams)
    }
}
