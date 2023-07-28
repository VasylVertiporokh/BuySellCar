//
//  SearchQueryBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 08.03.2023.
//

import Foundation

struct SearchParam: Hashable {
    let key: SearchKey
    var value: SearchValue
    
    var queryString: String {
        switch value {
        case .equalToInt(let intValue):
            return "\(key) = \(intValue)"
        case .equalToString(let stringValue):
            return "\(key) = '\(stringValue)'"
        case .greaterOrEqualTo(let intValue):
            return "\(key) >= \(intValue)"
        case .lessOrEqualTo(let intValue):
            return "\(key) <= \(intValue)"
        }
    }
}

// MARK: - SearchKey
enum SearchKey: String, Hashable {
    case price = "price"
    case bodyType = "bodyType"
    case transportName = "transportName"
    case transportModel = "transportModel"
    case transmissionType = "transmissionType"
    case mileage = "mileage"
    case yearOfManufacture = "yearOfManufacture"
    case power = "power"
    case fuelType = "fuelType"
    case sellerType = "sellerType"
}

// MARK: - Internal extension
extension SearchKey {
    var keyDescription: String {
        switch self {
        case .price:             return "Price:"
        case .bodyType:          return "Body:"
        case .transmissionType:  return "Transmission:"
        case .yearOfManufacture: return "Year:"
        case .fuelType:          return "Fuel:"
        case .sellerType:        return "Seller:"
        case .mileage:           return "Km:"
        case .power:             return "Hp:"
        case .transportName:     return "Brand:"
        case .transportModel:    return "Model:"
        }
    }
}

// MARK: - SearchValue
enum SearchValue: Hashable {
    case equalToString(stringValue: String)
    case equalToInt(intValue: Int)
    case greaterOrEqualTo(intValue: Int)
    case lessOrEqualTo(intValue: Int)
}

// MARK: - Internal extension
extension SearchValue {
    var searchValueDescription: String {
        switch self {
        case .equalToString(let stringValue):
            return stringValue
        case .equalToInt(let intValue):
            return "\(intValue)"
        case .greaterOrEqualTo(let intValue):
            return "from \(intValue)"
        case .lessOrEqualTo(let intValue):
            return "to \(intValue)"
        }
    }
}
