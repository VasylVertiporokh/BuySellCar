//
//  UserNetworkService.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 02.03.2023.
//

import Foundation
import Combine

protocol UserNetworkService {
    func logout(userToken: Token?) -> AnyPublisher<Void, NetworkError>
    func deleteUserAvatar(userId: String) -> AnyPublisher<Void, NetworkError>
    func addUserAvatar(data: MultipartItem, userId: String) -> AnyPublisher<UploadingImageResponseModel, NetworkError>
    func updateUser(_ userModel: UserInfoUpdateRequestModel, userId: String) -> AnyPublisher<UserResponseModel, NetworkError>
    func addToFavorite(objectId: String, userId: String) -> AnyPublisher<Void, NetworkError>
    func deleteFromFavorite(objectId: String, userId: String) -> AnyPublisher<Void, NetworkError>
    func loadFavorite(userId: String) -> AnyPublisher<FavoriteResponseModel, NetworkError>
}
