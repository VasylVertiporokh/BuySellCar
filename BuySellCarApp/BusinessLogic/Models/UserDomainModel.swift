//
//  UserDomainModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 01.03.2023.
//

import Foundation

struct UserDomainModel: Codable {
    var userName: String
    var ownerID: String
    var blUserLocale: String
    var email: String
    var objectID: String
    var userAvatar: String?
    var updated: Int?
    
    // MARK: - Map from LoginResponseModel
    init(responseModel: UserResponseModel) {
        userName = responseModel.name
        ownerID = responseModel.ownerID
        blUserLocale = responseModel.blUserLocale
        email = responseModel.email
        objectID = responseModel.objectID
        userAvatar = responseModel.userAvatar
        updated = responseModel.updated
    }
}
