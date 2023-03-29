//
//  AdvertisementServiceImpl.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.03.2023.
//

import Foundation
import Combine

final class AdvertisementServiceImpl {
    // MARK: - Internal properties
    private(set) lazy var advertisementCountPublisher = advertisementCountSubject.eraseToAnyPublisher()
    
    // MARK: - Private properties
    private let advertisementNetworkService: AdvertisementNetworkService
    
    // MARK: - Subjects
    private let advertisementCountSubject = CurrentValueSubject<AdvertisementCountResponseModel, Never>(.init(advertisementCount: ""))
    
    // MARK: - Init
    init(advertisementNetworkService: AdvertisementNetworkService) {
        self.advertisementNetworkService = advertisementNetworkService
    }
}

// MARK: - AdvertisementService
extension AdvertisementServiceImpl: AdvertisementService {
    func getAdvertisementObjects(pageSize: String) -> AnyPublisher<[AdvertisementResponseModel], NetworkError> {
        advertisementNetworkService.getAdvertisementObjects(pageSize: pageSize)
    }
    
    func searchAdvertisement(searchParams: [SearchParam]) -> AnyPublisher<[AdvertisementResponseModel], NetworkError> {
        advertisementNetworkService.getAdvertisementCount(searchParams: searchParams)
            .flatMap { [unowned self] addCount -> AnyPublisher<[AdvertisementResponseModel], NetworkError> in
                advertisementCountSubject.send(.init(advertisementCount: String(data: addCount, encoding: .utf8)))
                return advertisementNetworkService.searchAdvertisement(searchParams: searchParams)
            }
            .eraseToAnyPublisher()
    }
}
