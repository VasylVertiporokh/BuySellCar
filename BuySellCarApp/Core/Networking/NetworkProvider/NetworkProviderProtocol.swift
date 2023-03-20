//
//  NetworkProviderProtocol.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Foundation
import Combine

// MARK: - CombineNetworkServiceProtocol
protocol NetworkProviderProtocol {
    // MARK: - Associatedtype
    associatedtype Endpoint: EndpointBuilderProtocol
    
    // MARK: - Properties
    var apiInfo: ApiInfo { get }
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }
    
    // MARK: - Methods
    func performWithResponseModel<T: Decodable>(_ builder: Endpoint) -> AnyPublisher<T, NetworkError>
    func performWithProcessingResult(_ builder: Endpoint) -> AnyPublisher<Void, NetworkError>
}
