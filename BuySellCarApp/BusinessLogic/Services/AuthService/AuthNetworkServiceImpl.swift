//
//  AuthNetworkServiceImpl.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Foundation
import Combine

final class AuthNetworkServiceImpl<NetworkProvider: NetworkProviderProtocol> where NetworkProvider.Endpoint == AuthEndpoitsBuilder {
    // MARK: - Private properties
    private let provider: NetworkProvider
    
    // MARK: - Init
    init(_ service: NetworkProvider) {
        self.provider = service
    }
}

// MARK: - LoginNetworkServiceProtocol
extension AuthNetworkServiceImpl: AuthNetworkServiceProtocol {
    func login(loginModel: LoginRequestModel) -> AnyPublisher<UserResponseModel, NetworkError> {
        return provider.performWithResponseModel(.login(model: loginModel))
    }
    
    func createUserAndLogin(userModel: CreateUserRequsetModel) -> AnyPublisher<UserResponseModel, NetworkError> {
        provider.performWithProcessingResult(.createUser(model: userModel))
              .flatMap { [unowned self] _ -> AnyPublisher<UserResponseModel, NetworkError> in
                  return provider.performWithResponseModel(.login(model: .init(login: userModel.email, password: userModel.password)))
              }
              .eraseToAnyPublisher()
    }
    
    func restorePassword(userEmail: String) -> AnyPublisher<Void, NetworkError> {
        return provider.performWithProcessingResult(.restorePassword(email: userEmail))
    }
    
    func validateUserToken(token: Token) -> AnyPublisher<Bool, NetworkError> {
        return provider.performWithRawData(.tokenValidation(token: token))
            .flatMap { data -> AnyPublisher<Bool, NetworkError> in
                guard let isTokenValid = String(data: data, encoding: .utf8).flatMap(Bool.init) else {
                    return Fail(error: NetworkError.decodingError)
                        .eraseToAnyPublisher()
                }
                
                return Just(isTokenValid)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
