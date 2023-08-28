//
//  UserServiceImpl.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 01.03.2023.
//

import Foundation
import Combine

final class UserServiceImpl {
    // MARK: - Internal properties
    var isAuthorized: Bool {
        tokenStorage.token != nil
    }
    
    var user: UserDomainModel? {
        userDomainSubject.value
    }
    
    // MARK: - Private properties
    private let tokenStorage: TokenStorage
    private let userDefaultsService: UserDefaultsServiceProtocol
    private let userNetworkService: UserNetworkService
    
    // MARK: - Publisher
    private(set) lazy var userDomainPublisher = userDomainSubject.eraseToAnyPublisher()
    private let userDomainSubject = CurrentValueSubject<UserDomainModel?, Never>(nil)
    
    private(set) lazy var numberOfFavoriteAdsPublisher = numberOfFavoriteAdsSubject.eraseToAnyPublisher()
    private let numberOfFavoriteAdsSubject = CurrentValueSubject<Int, Never>(.zero)
    
    // MARK: - Init
    init(
        tokenStorage: TokenStorage,
        userDefaultsService: UserDefaultsServiceProtocol,
        userNetworkService: UserNetworkService
    ) {
        self.tokenStorage = tokenStorage
        self.userDefaultsService = userDefaultsService
        self.userNetworkService = userNetworkService
        createUserDomainPublisher()
    }
}

// MARK: - UserService
extension UserServiceImpl: UserService {
    func updateUser(userModel: UserInfoUpdateRequestModel, userId: String) -> AnyPublisher<UserResponseModel, NetworkError> {
        return userNetworkService.updateUser(userModel, userId: userId)
    }
    
    func updateAvatar(userAvatar: MultipartItem, userId: String) -> AnyPublisher<UserResponseModel, NetworkError> {
        userNetworkService.addUserAvatar(data: userAvatar, userId: userId)
            .flatMap { [unowned self] userAvatarPath -> AnyPublisher<UserResponseModel, NetworkError> in
                let userModel: UserInfoUpdateRequestModel = .init(userAvatar: userAvatarPath.fileURL)
                return userNetworkService.updateUser(userModel, userId: userId)
            }
            .eraseToAnyPublisher()
    }
    
    func deleteAvatar(userId: String) -> AnyPublisher<Void, NetworkError> {
        return updateUser(userModel: .init(userAvatar: ""), userId: userId)
            .flatMap { [unowned self] user -> AnyPublisher<Void, NetworkError> in
                saveUser(.init(responseModel: user))
                return userNetworkService.deleteUserAvatar(userId: userId)
            }
            .eraseToAnyPublisher()
    }
    
    func addToFavorite(objectId: String) -> AnyPublisher<FavoriteResponseModel, NetworkError> {
        guard let userId = user?.objectID else {
            return Fail(error: NetworkError.unexpectedError)
                .eraseToAnyPublisher()
        }
        return userNetworkService.addToFavorite(objectId: objectId, userId: userId)
            .flatMap { [unowned self] _ -> AnyPublisher<FavoriteResponseModel, NetworkError> in
                return userNetworkService.loadFavorite(userId: userId)
                    .handleEvents(receiveOutput: { [unowned self] model in
                        numberOfFavoriteAdsSubject.value = model.favorite.count
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func deleteFromFavorite(objectId: String) -> AnyPublisher<FavoriteResponseModel, NetworkError> {
        guard let userId = user?.objectID else {
            return Fail(error: NetworkError.unexpectedError)
                .eraseToAnyPublisher()
        }
        return userNetworkService.deleteFromFavorite(objectId: objectId, userId: userId)
            .flatMap { [unowned self] _ -> AnyPublisher<FavoriteResponseModel, NetworkError> in
                return userNetworkService.loadFavorite(userId: userId)
                    .handleEvents(receiveOutput: { [unowned self] model in
                        numberOfFavoriteAdsSubject.value = model.favorite.count
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getFavoriteAds() -> AnyPublisher<FavoriteResponseModel, NetworkError> {
        guard let userId = user?.objectID else {
            return Fail(error: NetworkError.unexpectedError)
                .eraseToAnyPublisher()
        }
        return userNetworkService.loadFavorite(userId: userId)
            .handleEvents(receiveOutput: { [unowned self] model in
                numberOfFavoriteAdsSubject.value = model.favorite.count
            })
            .eraseToAnyPublisher()
    }
    
    func saveUser(_ model: UserDomainModel) {
        try? userDefaultsService.saveObject(model, forKey: .userModel)
        userDomainSubject.value = model
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        userNetworkService.logout(userToken: tokenStorage.token)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func clear() {
        userDefaultsService.removeObject(forKey: .userModel)
        tokenStorage.clear()
    }
}

// MARK: - Private extension
private extension UserServiceImpl {
    func createUserDomainPublisher() {
        userDomainSubject.send(try? userDefaultsService.getObject(forKey: .userModel, castTo: UserDomainModel.self))
    }
}
