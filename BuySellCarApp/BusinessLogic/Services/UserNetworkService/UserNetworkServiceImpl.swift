//
//  UserNetworkServiceImpl.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 02.03.2023.
//

import Foundation
import Combine

final class UserNetworkServiceImpl<NetworkProvider: NetworkProviderProtocol> where NetworkProvider.Endpoint == UserEndpointsBuilder {
    
    // MARK: - Private properties
    private let provider: NetworkProvider
    
    // MARK: - Init
    init(_ provider: NetworkProvider) {
        self.provider = provider
    }
}

// MARK: - UserNetworkService
extension UserNetworkServiceImpl: UserNetworkService {
    func logout(userToken: String?) -> AnyPublisher<Never, NetworkError> {
        guard let userToken = userToken else {
            return Fail(error: NetworkError.tokenError)
                .eraseToAnyPublisher()
        }
        return provider.perfomWithProcessingResult(.logout(userToken))
    }
}
