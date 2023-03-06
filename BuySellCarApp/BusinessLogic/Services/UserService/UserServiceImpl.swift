//
//  UserServiceImpl.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 01.03.2023.
//

import Foundation
import Combine

final class UserServiceImpl {
     var user: UserDomainModel? {
        userDomainSubject.value
    }
    
    // MARK: - Private properties
    private let keychainService: KeychainService
    private let userDefaultsService: UserDefaultsServiceProtocol
    private let userNetworkService: UserNetworkService
    
    // MARK: - Publisher
    private(set) lazy var userDomainPublisher = userDomainSubject.eraseToAnyPublisher()
    private let userDomainSubject = CurrentValueSubject<UserDomainModel?, Never>(nil)
    
    // MARK: - Init
    init(
        keychainService: KeychainService,
        userDefaultsService: UserDefaultsServiceProtocol,
        userNetworkService: UserNetworkService
    ) {
        self.keychainService = keychainService
        self.userDefaultsService = userDefaultsService
        self.userNetworkService = userNetworkService
        createUserDomainPublisher()
    }
}

// MARK: - UserService
extension UserServiceImpl: UserService {
    func saveUser(_ model: UserDomainModel) {
        keychainService.saveToken(token: model.userToken)
        try? userDefaultsService.saveObject(model, forKey: .userModel)
        userDomainSubject.value = model
    }
    
    func getToken() -> String? {
        keychainService.token
    }
    
    func logout() -> AnyPublisher<Never, Error> {
         userNetworkService.logout(userToken: keychainService.token)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func clear() {
        userDefaultsService.removeObject(forKey: .userModel)
//        keychainService.clear()
    }
}

// MARK: - Private extension
private extension UserServiceImpl {
    func createUserDomainPublisher() {
        userDomainSubject.send(try? userDefaultsService.getObject(forKey: .userModel, castTo: UserDomainModel.self))
    }
}
