//
//  UserServiceImpl.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 01.03.2023.
//

import Foundation
import Combine

final class UserServiceImpl {
    // MARK: - Private properties
    private let keychainService: KeychainService
    private let userDefaultsService: UserDefaultsServiceProtocol
    private let userNetworkService: UserNetworkService
    private var cancellables = Set<AnyCancellable>()
    
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
    
    func getUser() -> UserDomainModel? {
        try? userDefaultsService.getObject(forKey: .userModel, castTo: UserDomainModel.self)
    }
    
    func getToken() -> String? {
        keychainService.token
    }
    
    func logout() -> AnyPublisher<Never, NetworkError> {
        userNetworkService.logout(userToken: keychainService.token)
    }

    func deleteUser() {
        userDefaultsService.removeObject(forKey: .userModel)
        keychainService.clear()
    }
}

// MARK: - Private extension
private extension UserServiceImpl {
    func createUserDomainPublisher() {
        userDomainSubject.send(try? userDefaultsService.getObject(forKey: .userModel, castTo: UserDomainModel.self))
    }
}
