//
//  UserServiceProtocol.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 01.03.2023.
//

import Foundation
import Combine

protocol UserService {
    var userDomainPublisher: AnyPublisher<UserDomainModel?, Never> { get }
    var user: UserDomainModel? { get }
    
    func updateUser(userData: Data, userId: String) -> AnyPublisher<UserResponseModel, NetworkError>
    func updateAvatar(userAvatar: MultipartItem, userId: String) -> AnyPublisher<UserResponseModel, NetworkError>
    func deleteAvatar(userId: String) -> AnyPublisher<Void, NetworkError>
    func logout() -> AnyPublisher<Void, Error>
    
    func saveUser(_ model: UserDomainModel)
    func saveToken(_ token: String?)
    func getToken() -> String?
    func clear()
}
