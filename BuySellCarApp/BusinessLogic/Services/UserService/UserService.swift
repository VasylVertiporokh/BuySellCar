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
    
    func saveUser(_ model: UserDomainModel)
    func getUser() -> UserDomainModel?
    func getToken() -> String?
    func logout() -> AnyPublisher<Never, NetworkError>
    func deleteUser()
}
