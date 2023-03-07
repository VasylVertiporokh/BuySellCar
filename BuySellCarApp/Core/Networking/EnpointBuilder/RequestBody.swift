//
//  RequestBody.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 21.02.2023.
//

import Foundation

// MARK: - RequestBody
enum RequestBody {
    case rawData(Data)
    case encodable(Encodable)
}
