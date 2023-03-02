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
}
