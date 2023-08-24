//
//  UserEndpointsBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 02.03.2023.
//

import Foundation

enum UserEndpointsBuilder {
    case logout(Token)
    case deleteAvatar(userId: String)
    case addUserAvatar(item: MultipartItem, userId: String)
    case updateUser(userModel: UserInfoUpdateRequestModel, userId: String)
    case addToFavorite(objectId: String, objectData: Data)
    case deleteFromFavorite(objectId: String, objectData: Data)
    case getFavorite(userId: String)
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
        case .addToFavorite(let objectId, _):
            return "data/users/\(objectId)/favorite"
        case .deleteFromFavorite(let objectId, _):
            return "data/users/\(objectId)/favorite"
        case .getFavorite(let userId):
            return "data/users/\(userId)"
        }
    }
    var headerFields: [String : String] {
        switch self {
        case .logout(let token):
            return [
                "Content-Type" : "application/json",
                "user-token" : token.value
            ]
        case .deleteAvatar, .updateUser, .addToFavorite, .getFavorite, .deleteFromFavorite:
            return ["Content-Type" : "application/json"]
        case .addUserAvatar:
            return ["" : ""]
        }
    }
     
    var method: HTTPMethod {
        switch self {
        case .logout:              return .get
        case .deleteAvatar:        return .delete
        case .addUserAvatar:       return .post
        case .updateUser:          return .put
        case .addToFavorite:       return .put
        case .deleteFromFavorite:  return .delete
        case .getFavorite:         return .get
        }
    }
    
    var query: [String : String]? {
        switch self {
        case .addUserAvatar:
            return ["overwrite" : "true"]
        case .getFavorite:
            return ["loadRelations" : "favorite.userData"]
        default:
            return nil
        }
    }
    
    var body: RequestBody? {
        switch self {
        case .logout, .deleteAvatar, .getFavorite:
            return nil
        case .addUserAvatar(let item, _):
            return .multipartBody([item])
        case .updateUser(let userModel, _):
            return .encodable(userModel)
        case .addToFavorite(_, let data):
            return .rawData(data)
        case .deleteFromFavorite(_, let data):
            return .rawData(data)
        }
    }
}
