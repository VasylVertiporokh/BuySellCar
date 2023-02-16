//
//  CombineNetworkServiceProtocol.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Foundation
import Combine

// MARK: - CombineNetworkServiceProtocol
protocol CombineNetworkServiceProtocol {
    // MARK: - Associatedtype
    associatedtype Endpoint: EndpointBuilderProtocol

    // MARK: - Properties
    var baseUrl: URL { get }
    var decoder: JSONDecoder { get }
    var urlSession: URLSession { get }

    // MARK: - Methods
    func perfom<T: Decodable>(_ builder: Endpoint) -> AnyPublisher<T, NetworkError>
    func perfom(_ builder: Endpoint) -> AnyPublisher<Never, NetworkError>
    func resumeDataTask(_ builder: Endpoint) -> AnyPublisher<Data, NetworkError>
}
