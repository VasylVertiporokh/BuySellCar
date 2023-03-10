//
//  UserEndpointsBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 02.03.2023.
//

import Foundation

enum UserEndpointsBuilder {
    case logout(String)
    case addUserAvatar(item: MultipartItem, userId: String)
}

// MARK: - EndpointBuilderProtocol
extension UserEndpointsBuilder: EndpointBuilderProtocol {
    var path: String {
        switch self {
        case .logout:
            return "/users/logout"
        case .addUserAvatar(let dataItem, let userId):
            return "/files/images/users/\(userId)/\(dataItem.fileName)"
        }
    }
    
    var headerFields: [String : String] {
        switch self {
        case .logout(let token):
            return [
                "application/json" : "Content-Type",
                token : "user-token"
            ]
        case .addUserAvatar:
            return ["" : ""]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .logout:
            return .get
        case .addUserAvatar:
            return .post
        }
    }
    
    var body: RequestBody? {
        switch self {
        case .logout:
            return nil
        case .addUserAvatar(let item, _):
            return .multipartBody([item])
        }
    }
}
