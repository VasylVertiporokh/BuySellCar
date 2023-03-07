//
//  LoginResponseModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Foundation

struct LoginResponseModel: Decodable {
    let ownerID: String
    let name: String
    let blUserLocale: String
    let userToken: String
    let email: String
    let objectID: String
    
    enum CodingKeys: String, CodingKey {
        case ownerID = "ownerId"
        case objectID = "objectId"
        case userToken = "user-token"
        case name, blUserLocale, email
    }
}
