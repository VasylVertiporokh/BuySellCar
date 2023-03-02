//
//  CreateUserResponseModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 24.02.2023.
//

import Foundation

struct CreateUserResponseModel: Decodable {
//    let lastLogin: Date
    let userStatus: String
    let created: Int
    let ownerId: String
    let name: String
    let email: String
    let objectId: String
}
