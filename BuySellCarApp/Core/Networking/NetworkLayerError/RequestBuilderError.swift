//
//  RequestBuilderError.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.02.2023.
//

import Foundation

enum RequestBuilderError: Error {
    case bodyEncodingError
    case badURL
    case badURLComponents
}

extension RequestBuilderError: LocalizedError {
    var requestErrorDescription: String? {
        switch self {
        case .bodyEncodingError:
            return "Error encoding the body"
        case .badURL:
            return "Bad request URL"
        case .badURLComponents:
            return "Bad URL components"
        }
    }
}
