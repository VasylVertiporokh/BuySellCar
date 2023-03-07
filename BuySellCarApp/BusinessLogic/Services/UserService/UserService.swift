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
    
    func saveUser(_ model: UserDomainModel)
    func getToken() -> String?
    func logout() -> AnyPublisher<Never, Error>
    func clear()
}
