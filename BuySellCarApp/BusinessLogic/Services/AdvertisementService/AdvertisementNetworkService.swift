//
//  AdvertisementNetworkService.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 07.03.2023.
//

import Foundation
import Combine

protocol AdvertisementNetworkService {
    func searchAdvertisement(searchParam: SearchAdvertisementQueryBuilder) -> AnyPublisher<Never, NetworkError>
}













protocol SearchAdvertisementQueryBuilder {
    var dictionaryFromOwnFields: [String: String] { get }
    var searchQueryParam: String { get }
}

extension SearchAdvertisementQueryBuilder {
    var searchQueryParam: String {
        return dictionaryFromOwnFields.map { $0.0 + " = " + $0.1 }.joined(separator: " and ")
    }
}

struct AdvertisementSearchModel {
    // MARK: - Properties with default value
    var minPrice: String = String(Int.zero)
    var maxPrice: String = String(Int.max)
    var minMileage: String = String(Int.zero)
    var maxMileage: String = String(Int.max)
    var minYearOfManufacture: String = String(1950)
    var maxYearOfManufacture: String = String(Calendar.current.component(.year, from: Date()))
    
    // MARK: - Optional search properties
    var bodyType: String?
    var transportName: String?
    var bodyColor: String?
    var price: String?
    var interiorColor: String?
    var transmissionType: String?
    var mileage: String?
    var doorCount: String?
    var yearOfManufacture: String?
    var transportModel: String?
    var condition: String?
    var fuelType: String?
    var sellerType: String?
}

// MARK: - SearchAdvertisementQueryBuilder
extension AdvertisementSearchModel: SearchAdvertisementQueryBuilder {
    var dictionaryFromOwnFields: [String : String] {
        let priceRange = "\(minPrice) or price <= \(maxPrice)"
        let mileageRange = "\(minMileage) or mileage <= \(maxMileage)"
        let yearOfManufactureRange = "\(minYearOfManufacture) or yearOfManufacture <= \(maxYearOfManufacture)"
        
        let fieldsDict = [
            "bodyType": bodyType,
            "transportName": transportName,
            "transportModel": transportModel,
            "bodyColor": bodyColor,
            "price": priceRange,
            "interiorColor": interiorColor,
            "mileage": mileageRange,
            "doorCount": doorCount,
            "yearOfManufacture": yearOfManufactureRange,
            "condition": condition,
            "fuelType": fuelType,
            "sellerType": sellerType
        ]
        return fieldsDict.compactMapValues { $0 }
    }
}
