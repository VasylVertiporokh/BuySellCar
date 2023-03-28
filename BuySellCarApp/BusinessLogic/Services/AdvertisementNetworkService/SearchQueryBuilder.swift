//
//  SearchQueryBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 08.03.2023.
//

import Foundation

struct SearchParam: Hashable {
    let key: SearchKey
    let value: SearchValue
}

// MARK: - SearchKey
enum SearchKey: String, Hashable {
    case price = "price"
    case bodyColor = "bodyColor"
    case bodyType = "bodyType"
    case transportName = "transportName"
    case transportModel = "transportModel"
    case interiorColor = "interiorColor"
    case transmissionType = "transmissionType"
    case mileage = "mileage"
    case doorCount = "doorCount"
    case yearOfManufacture = "yearOfManufacture"
    case condition = "condition"
    case fuelType = "fuelType"
    case sellerType = "sellerType"
}

// MARK: - SearchValue
enum SearchValue: Hashable {
    case equalToString(stringValue: String)
    case equalToInt(intValue: Int)
    case greaterOrEqualTo(intValue: Int)
    case lessOrEqualTo(intValue: Int)
}
