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
    func updateUser(userData: Data, userId: String) -> AnyPublisher<UserResponseModel, NetworkError> {
        return userNetworkService.updateUser(userData, userId: userId)
    }
    
    func updateAvatar(userAvatar: MultipartItem, userId: String) -> AnyPublisher<UserResponseModel, NetworkError> {
        userNetworkService.addUserAvatar(data: userAvatar, userId: userId)
            .flatMap { [unowned self] userAvatarPath -> AnyPublisher<UserResponseModel, NetworkError> in
                guard let parameters = "{\n\"userAvatar\": \"\(userAvatarPath.fileURL)\"\n}".data(using: .utf8) else {
                    return Fail(error: .unexpectedError)
                        .eraseToAnyPublisher()
                }
                return userNetworkService.updateUser(parameters, userId: userId)
            }
            .eraseToAnyPublisher()
    }
    
    func deleteAvatar(userId: String) -> AnyPublisher<Void, NetworkError> {
        guard let parameters = "{\"userAvatar\": null\n}".data(using: .utf8) else {
            return Fail(error: NetworkError.unexpectedError).eraseToAnyPublisher()
        }
        return updateUser(userData: parameters, userId: userId)
            .flatMap { [unowned self] user -> AnyPublisher<Void, NetworkError> in
                saveUser(.init(responseModel: user))
                return userNetworkService.deleteUserAvatar(userId: userId)
            }
            .eraseToAnyPublisher()
    }

    
//    func test(userId: String) -> AnyPublisher<Void, NetworkError> {
//        guard let parameters = "{\"userAvatar\": null\n}".data(using: .utf8) else {
//            return Fail(error: NetworkError.unexpectedError).eraseToAnyPublisher()
//        }
//       return userNetworkService.updateUser(parameters, userId: userId)
//            .handleEvents(receiveOutput: { [unowned self] in
//                saveUser(.init(responseModel: $0))
//            })
//            .flatMap { [unowned self] _ -> AnyPublisher<Void, NetworkError> in
//                return deleteAvatar(userId: userId)
//            }
//            .eraseToAnyPublisher()
//    }
    
    func saveUser(_ model: UserDomainModel) {
        try? userDefaultsService.saveObject(model, forKey: .userModel)
        userDomainSubject.value = model
    }
    
    func saveToken(_ token: String?) {
        guard let token = token else { return }
        keychainService.saveToken(token: token)
    }
    
    func getToken() -> String? {
        keychainService.token
    }
    
    func logout() -> AnyPublisher<Void, Error> {
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
