//
//  UserEndpointsBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 02.03.2023.
//

import Foundation

enum UserEndpointsBuilder {
    case logout(String)
}

// MARK: - EndpointBuilderProtocol
extension UserEndpointsBuilder: EndpointBuilderProtocol {
    var path: String {
        switch self {
        case .logout:
            return "/users/logout"
        }
    }
    
    var headerFields: [String : String] {
        switch self {
        case .logout(let token):
            return [
                "application/json" : "Content-Type",
                token : "user-token"
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .logout:
            return .get
        }
    }
}
