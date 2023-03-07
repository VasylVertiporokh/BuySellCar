//
//  UserDefaultsServiceError.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.02.2023.
//

import Foundation

enum UserDefaultsServiceError {
    case unableToEncode
    case noValue
    case unableToDecode
}

// MARK: - LocalizedError
extension UserDefaultsServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unableToEncode:
            return "Unable to encode object into data"
        case .noValue:
            return "No data object found for the given key"
        case .unableToDecode:
            return "Unable to decode object into given type"
        }
    }
}
