//
//  NetworkService.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Foundation
import Combine

final class NetworkServiceProvider<Endpoint: EndpointBuilderProtocol>: NetworkProviderProtocol {
    // MARK: - Internal properties
    private(set) var apiInfo: ApiInfo
    private(set) var decoder: JSONDecoder
    private(set) var encoder: JSONEncoder
    
    // MARK: - Private properties
    private let networkManager: NetworkManagerProtocol

    // MARK: - Init
    init(
        apiInfo: ApiInfo,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        networkManager: NetworkManagerProtocol
    ) {
        self.apiInfo = apiInfo
        self.decoder = decoder
        self.encoder = encoder
        self.networkManager = networkManager
    }
    
    // MARK: - Internal methods
    func performWithResponseModel<T: Decodable>(_ builder: Endpoint) -> AnyPublisher<T, NetworkError> {
        do {
            let request = try builder.createRequest(apiInfo.baseURL, encoder)
            return networkManager.resumeDataTask(request)
                .decode(type: T.self, decoder: decoder)
                .mapError { error -> NetworkError in
                    guard let _ = error as? DecodingError else {
                        guard let error = error as? NetworkError else {
                            return .unexpectedError
                        }
                        return error
                    }
                    return NetworkError.decodingError
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.requestError(error as! RequestBuilderError))
                .eraseToAnyPublisher()
        }
    }
    
    func performWithProcessingResult(_ builder: Endpoint) -> AnyPublisher<Void, NetworkError> {
        do {
            let request = try builder.createRequest(apiInfo.baseURL, encoder)
            return networkManager.resumeDataTask(request)
                .map { _ in } 
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.requestError(error as! RequestBuilderError))
                .eraseToAnyPublisher()
        }
    }
    
    func performWithRawData(_ builder: Endpoint) -> AnyPublisher<Data, NetworkError> {
        do {
            let request = try builder.createRequest(apiInfo.baseURL, encoder)
            return networkManager.resumeDataTask(request)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.requestError(error as! RequestBuilderError))
                .eraseToAnyPublisher()
        }
    }
}
