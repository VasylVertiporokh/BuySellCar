//
//  UserNetworkService.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 02.03.2023.
//

import Foundation
import Combine

protocol UserNetworkService {
    func logout(userToken: String?) -> AnyPublisher<Never, NetworkError>
    func addUserAvatar(data: MultipartItem, userId: String) -> AnyPublisher<Never, NetworkError> // TODO: - fix never
}
