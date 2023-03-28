//
//  AdvertisementNetworkImpl.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 07.03.2023.
//

import Foundation
import Combine

final class AdvertisementNetworkImpl<NetworkProvider: NetworkProviderProtocol> where NetworkProvider.Endpoint == AdvertisementEndpointBuilder {
    // MARK: - Private properties
    private let provider: NetworkProvider
    
    // MARK: - Init
    init(provider: NetworkProvider) {
        self.provider = provider
    }
}

// MARK: - AdvertisementNetworkService
extension AdvertisementNetworkImpl: AdvertisementNetworkService {
    func getAdvertisementObjects(pageSize: String) -> AnyPublisher<[AdvertisementResponseModel], NetworkError> {
        provider.performWithResponseModel(.getAdvertisement(pageSize: pageSize))
    }
    
    func searchAdvertisement(searchParams: [SearchParam]) -> AnyPublisher<[AdvertisementResponseModel], NetworkError> {
        provider.performWithResponseModel(.searchAdvertisement(searchParams))
    }
}
