//
//  CreateUserRequsetModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 24.02.2023.
//

import Foundation

struct CreateUserRequsetModel: Encodable {
    let email: String
    let password: String
    let name: String
    let accountType: String = ""
}
