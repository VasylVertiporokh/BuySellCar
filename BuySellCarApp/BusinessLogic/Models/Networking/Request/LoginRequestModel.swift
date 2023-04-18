//
//  LoginRequestModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Foundation

struct LoginRequestModel: Encodable {
    let login: String
    let password: String
}
