//
//  UserServiceProtocol.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 01.03.2023.
//

import Foundation
import Combine

protocol UserService {
    var isAuthorized: Bool { get }
    var userDomainPublisher: AnyPublisher<UserDomainModel?, Never> { get }
    var numberOfFavoriteAdsPublisher: AnyPublisher<Int, Never> { get }
    var user: UserDomainModel? { get }
    
    func updateUser(userModel: UserInfoUpdateRequestModel, userId: String) -> AnyPublisher<UserResponseModel, NetworkError>
    func updateAvatar(userAvatar: MultipartItem, userId: String) -> AnyPublisher<UserResponseModel, NetworkError>
    func deleteAvatar(userId: String) -> AnyPublisher<Void, NetworkError>
    func addToFavorite(objectId: String) -> AnyPublisher<FavoriteResponseModel, NetworkError>
    func getFavoriteAds() -> AnyPublisher<FavoriteResponseModel, NetworkError>
    func deleteFromFavorite(objectId: String) -> AnyPublisher<FavoriteResponseModel, NetworkError>
    func logout() -> AnyPublisher<Void, Error>
    func saveUser(_ model: UserDomainModel)
    func clear()
}
