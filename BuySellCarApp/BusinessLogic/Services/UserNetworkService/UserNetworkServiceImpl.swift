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
    func logout(userToken: Token?) -> AnyPublisher<Void, NetworkError> {
        guard let userToken = userToken else {
            return Fail(error: NetworkError.unexpectedError)
                .eraseToAnyPublisher()
        }
        return provider.performWithProcessingResult(.logout(userToken))
    }
    
    func deleteUserAvatar(userId: String) -> AnyPublisher<Void, NetworkError> {
        return provider.performWithProcessingResult(.deleteAvatar(userId: userId))
    }
    
    func addUserAvatar(data: MultipartItem, userId: String) -> AnyPublisher<UploadingImageResponseModel, NetworkError> {
        return provider.performWithResponseModel(.addUserAvatar(item: data, userId: userId))
    }
    
    func updateUser(_ userModel: UserInfoUpdateRequestModel, userId: String) -> AnyPublisher<UserResponseModel, NetworkError> {
        return provider.performWithResponseModel(.updateUser(userModel: userModel, userId: userId))
    }
    
    func addToFavorite(objectId: String, userId: String) -> AnyPublisher<Void, NetworkError> {
        let objectData: [String] = [objectId]
        do {
            let data = try JSONSerialization.data(withJSONObject: objectData, options: [])
            return provider.performWithProcessingResult(.addToFavorite(objectId: userId, objectData: data))
        } catch {
            return Fail(error: NetworkError.unexpectedError)
                .eraseToAnyPublisher()
        }
    }
    
    func deleteFromFavorite(objectId: String, userId: String) -> AnyPublisher<Void, NetworkError> {
        let objectData: [String] = [objectId]
        do {
            let data = try JSONSerialization.data(withJSONObject: objectData, options: [])
            return provider.performWithProcessingResult(.deleteFromFavorite(objectId: userId, objectData: data))
        } catch {
            return Fail(error: NetworkError.unexpectedError)
                .eraseToAnyPublisher()
        }
    }
    
    func loadFavorite(userId: String) -> AnyPublisher<FavoriteResponseModel, NetworkError> {
        return provider.performWithResponseModel(.getFavorite(userId: userId))
    }
}
