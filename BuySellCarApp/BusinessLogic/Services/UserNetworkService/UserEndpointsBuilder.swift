//
//  UserEndpointsBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 02.03.2023.
//

import Foundation

enum UserEndpointsBuilder {
    case logout(String)
    case deleteAvatar(userId: String)
    case addUserAvatar(item: MultipartItem, userId: String)
    case updateUser(userData: Data, userId: String)
}

// MARK: - EndpointBuilderProtocol
extension UserEndpointsBuilder: EndpointBuilderProtocol {
    var path: String {
        switch self {
        case .logout:
            return "/users/logout"
        case .deleteAvatar(let userId):
            return "/files/images/users/\(userId)/avatar.png"
        case .addUserAvatar(let dataItem, let userId):
            return "/files/images/users/\(userId)/\(dataItem.fileName)"
        case .updateUser(_, let userId):
            return "/users/\(userId)"
        }
    }
    var headerFields: [String : String] {
        switch self {
        case .logout(let token):
            return [
                "application/json" : "Content-Type",
                token : "user-token"
            ]
        case .deleteAvatar:
            return ["application/json" : "Content-Type"]
        case .addUserAvatar:
            return ["" : ""]
        case .updateUser:
            return ["application/json" : "Content-Type"]
        }
    }
     
    var method: HTTPMethod {
        switch self {
        case .logout:
            return .get
        case .deleteAvatar:
            return .delete
        case .addUserAvatar:
            return .post
        case .updateUser:
            return .put
        }
    }
    
    var query: [String : String]? {
        switch self {
        case .addUserAvatar:
            return ["overwrite" : "true"]
        default:
            return nil
        }
    }
    
    var body: RequestBody? {
        switch self {
        case .logout:
            return nil
        case .deleteAvatar:
            return nil
        case .addUserAvatar(let item, _):
            return .multipartBody([item])
        case .updateUser(let userData, _):
            return .rawData(userData)
        }
    }
}
