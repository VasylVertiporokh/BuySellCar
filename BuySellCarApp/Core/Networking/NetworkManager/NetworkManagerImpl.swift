//
//  NetworkManagerImpl.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 21.02.2023.
//

import Foundation
import Combine

final class NetworkManagerImpl: NetworkManagerProtocol {
    // MARK: - Private properties
    private let urlSession: URLSession
    
    // MARK: - Init
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
}

// MARK: - Internal extension
extension NetworkManagerImpl {
    func resumeDataTask(_ requset: URLRequest) -> AnyPublisher<Data, NetworkError> {
        return urlSession.dataTaskPublisher(for: requset)
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
}

// MARK: - Private extension
private extension NetworkManagerImpl {
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
            return Fail(error: NetworkError.clientError(output.data))
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
        case NSURLErrorCannotFindHost:
            return .hostError
        case NSURLErrorCannotConnectToHost:
            return .hostError
        case NSURLErrorHTTPTooManyRedirects:
            return .tooManyRedirectsError
        case NSURLErrorResourceUnavailable:
            return .resourceUnavailable
        default: return .unexpectedError
        }
    }
}
