//
//  ApiErrorResponseModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 17.02.2023.
//

import Foundation

struct ApiErrorResponseModel: Decodable {
    let code: Int
    let message: String
}
