//
//  NetworkError.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Foundation

// MARK: - NetworkErrorEnum
enum NetworkError: Error {
    case clientError
    case serverError
    case decodingError
    case unexpectedError
    case badURLError
    case timedOutError
    case hostError
    case tooManyRedirectsError
    case resourceUnavailable
}

// MARK: - LocalizedError
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .clientError:
            return "An error occurred on the client side. Please try again later."
        case .serverError:
            return "An error occurred on the server side. Please try again later."
        case .decodingError:
            return "We were unable to identify the data that came from the server. Please try again later."
        case .unexpectedError:
            return "For unknown reasons, something went wrong. Please try again later."
        case .badURLError:
            return "Bad URL Error. Please try again later."
        case .timedOutError:
            return "Timed Out Error. Please check your internet connection."
        case .hostError:
            return "Host Error. Please try again later."
        case .tooManyRedirectsError:
            return "Too Many Redirects. Please try again later."
        case .resourceUnavailable:
            return "Resource Unavailable. Please try again later."
        }
    }
}
