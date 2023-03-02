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
    func login(loginModel: LoginRequestModel) -> AnyPublisher<LoginResponseModel, NetworkError> {
        return provider.perfomWithResponseModel(.login(model: loginModel))
    }
    
    func creteUser(userModel: CreateUserRequsetModel) -> AnyPublisher<CreateUserResponseModel, NetworkError> {
        return provider.perfomWithResponseModel(.createUser(model: userModel))
    }
    
    func restorePassword(userEmail: String) -> AnyPublisher<Never, NetworkError> {
        return provider.perfomWithProcessingResult(.restorePassword(email: userEmail))
    }
}
