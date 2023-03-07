//
//  NetworkManagerProtocol.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 21.02.2023.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func resumeDataTask(_ requset: URLRequest) -> AnyPublisher<Data, NetworkError>
}
