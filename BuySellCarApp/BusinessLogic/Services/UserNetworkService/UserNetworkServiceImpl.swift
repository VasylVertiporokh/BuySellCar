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
    func logout(userToken: String?) -> AnyPublisher<Void, NetworkError> {
        guard let userToken = userToken else {
            return Fail(error: NetworkError.tokenError)
                .eraseToAnyPublisher()
        }
        return provider.performWithProcessingResult(.logout(userToken))
    }
    
    func deleteUserAvatar(userId: String) -> AnyPublisher<Void, NetworkError> {
        return provider.performWithProcessingResult(.deleteAvatar(userId: userId))
    }
    
    func addUserAvatar(data: MultipartItem, userId: String) -> AnyPublisher<UserAvatarResponseModel, NetworkError> {
        return provider.performWithResponseModel(.addUserAvatar(item: data, userId: userId))
    }
    
    func updateUser(_ userData: Data, userId: String) -> AnyPublisher<UserResponseModel, NetworkError> {
        return provider.performWithResponseModel(.updateUser(userData: userData, userId: userId))
    }
}
