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
    var userToken: String
    var email: String
    var objectID: String
    
    // MARK: - Map from LoginResponseModel
    init(responseModel: LoginResponseModel) {
        userName = responseModel.name
        ownerID = responseModel.ownerID
        blUserLocale = responseModel.blUserLocale
        userToken = responseModel.userToken
        email = responseModel.email
        objectID = responseModel.objectID
    }
}
