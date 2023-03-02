//
//  AuthNetworkServiceProtocol.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Foundation
import Combine

protocol AuthNetworkServiceProtocol {
    func login(loginModel: LoginRequestModel) -> AnyPublisher<LoginResponseModel, NetworkError>
    func creteUser(userModel: CreateUserRequsetModel) -> AnyPublisher<CreateUserResponseModel, NetworkError>
    func restorePassword(userEmail: String) -> AnyPublisher<Never, NetworkError>
}
