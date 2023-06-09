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
    var valueType: ValueType = .min
    
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
    
    enum ValueType {
        case min
        case max
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
        case .mileage:           return "km"
        case .power:             return "hp"
        case .transportName:     return "Model"
        case .transportModel:    return "model"
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
    
    var rangeType: RangeValueType {
        switch self {
        case .greaterOrEqualTo: return .min
        case .lessOrEqualTo:    return .max
        default:                return .none
        }
    }
}


enum RangeValueType {
    case none
    case min
    case max
}
