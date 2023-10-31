//
//  NetworkError.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Foundation

// MARK: - NetworkErrorEnum
enum NetworkError: Error {
    case clientError(Data?)
    case serverError
    case decodingError
    case unexpectedError
    case badURLError
    case timedOutError
    case hostError
    case tooManyRedirectsError
    case resourceUnavailable
    case tokenError(Data?)
    case requestError(RequestBuilderError)
}

// MARK: - Server error code
enum ApiErrorCode: Int {
    case accessToAccountDenied = 3064
    case invalidCredential = 3003
}

// MARK: - LocalizedError
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .clientError(let data):
            let defaultMessege = "An error occurred on the client side. Please try again later."
            guard let data = data,
                  let model = try? JSONDecoder().decode(ApiErrorResponseModel.self, from: data) else {
                return defaultMessege
            }
            return model.message
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
        case .tokenError(let data):
            let defaultMessege = "Token error"
            guard let data = data,
                  let model = try? JSONDecoder().decode(ApiErrorResponseModel.self, from: data) else {
                return defaultMessege
            }
            
            switch model.code {
            case ApiErrorCode.accessToAccountDenied.rawValue:
                return "You need to log in to your account again, the login data was used on another device"
            case ApiErrorCode.invalidCredential.rawValue:
                return model.message
            default:
                return defaultMessege
            }

        case .requestError(let error):
            return error.requestErrorDescription
        }
    }
}
