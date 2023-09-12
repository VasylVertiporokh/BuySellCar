//
//  AdsStorageError.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 06/09/2023.
//

import Foundation

enum AdsStorageError: Error {
    case fetchFavoriteError
    case saveError
    case defaultError
}

// MARK: - LocalizedError
extension AdsStorageError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fetchFavoriteError:
            return "Something went wrong while trying to retrieve Favorites from the local storage"
        case .saveError:
            return "An error occurred while trying to save to local storage"
        case .defaultError:
            return "Oops something went wrong("
        }
    }
}
