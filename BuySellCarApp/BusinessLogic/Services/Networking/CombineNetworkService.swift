//
//  CombineNetworkService.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Foundation
import Combine

final class CombineNetworkService<Endpoint: EndpointBuilderProtocol>: CombineNetworkServiceProtocol {
    // MARK: - Internal properties
    var baseUrl: URL
    var decoder: JSONDecoder
    var urlSession: URLSession

    // MARK: - Init
    init(
        baseUrl: URL,
        endpointBuilder: Endpoint.Type,
        decoder: JSONDecoder = JSONDecoder(),
        urlSession: URLSession = URLSession.shared
    ) {
        self.decoder = decoder
        self.urlSession = urlSession
        self.baseUrl = baseUrl
    }

    // MARK: - Internal methods
    func resumeDataTask(_ builder: Endpoint) -> AnyPublisher<Data, NetworkError> {
        let request = builder.createRequest(baseUrl: baseUrl)
        return urlSession.dataTaskPublisher(for: request)
            .mapError { [weak self] error -> NetworkError in
                guard let self = self else {
                    return NetworkError.unexpectedError
                }
                return self.convertError(error: error as NSError)
            }
            .flatMap { [weak self] output -> AnyPublisher<Data, NetworkError> in
                guard let self = self else {
                    return Fail(error: .unexpectedError)
                        .eraseToAnyPublisher()
                }
                return self.handleError(output)
            }
            .eraseToAnyPublisher()
    }

    func perfom<T: Decodable>(_ builder: Endpoint) -> AnyPublisher<T, NetworkError> {
        resumeDataTask(builder)
            .decode(
                type: T.self,
                decoder: decoder
            )
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
    }

    func perfom(_ builder: Endpoint) -> AnyPublisher<Never, NetworkError> {
        resumeDataTask(builder)
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
}

// MARK: - Private extension
private extension CombineNetworkService {
    func handleError(_ output: URLSession.DataTaskPublisher.Output) -> AnyPublisher<Data, NetworkError> {
        guard let httpResponse = output.response as? HTTPURLResponse else {
            fatalError()
        }
        switch httpResponse.statusCode {
        case 200...399:
            return Just(output.data)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        case 400...499:
            return Fail(error: NetworkError.clientError)
                .eraseToAnyPublisher()
        case 500...599:
            return Fail(error: NetworkError.serverError)
                .eraseToAnyPublisher()
        default:
            return Fail(error: NetworkError.unexpectedError)
                .eraseToAnyPublisher()
        }
    }

    func convertError(error: NSError) -> NetworkError {
        switch error.code {
        case NSURLErrorBadURL:
            return .badURLError
        case NSURLErrorTimedOut:
            return .timedOutError
        case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
            return .hostError
        case NSURLErrorHTTPTooManyRedirects:
            return .tooManyRedirectsError
        case NSURLErrorResourceUnavailable:
            return .resourceUnavailable
        default: return .unexpectedError
        }
    }
}
