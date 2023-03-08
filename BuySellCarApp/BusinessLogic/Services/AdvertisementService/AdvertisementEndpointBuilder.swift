//
//  AdvertisementEndpointBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 07.03.2023.
//

import Foundation

enum AdvertisementEndpointBuilder {
    case searchAdvertisement([SearchParam])
}

// MARK: - EndpointBuilderProtocol
extension AdvertisementEndpointBuilder: EndpointBuilderProtocol {
    var path: String {
        switch self {
        case .searchAdvertisement:
            return "/data/Advertisement"
        }
    }
    
    var headerFields: [String : String] {
        switch self {
        case .searchAdvertisement:
            return ["application/json" : "Content-Type"]
        }
    }
    
    var query: [String : String]? {
        switch self {
        case .searchAdvertisement(let searchParams):
            var searchProps: [String] = []
            for param in searchParams {
                switch param.value {
                case .equalToInt(let intValue):
                    searchProps.append("\(param.key) = \(intValue)")
                case .equalToString(let stringValue):
                    searchProps.append("\(param.key) = '\(stringValue)'")
                case .greaterOrEqualTo(let intValue):
                    searchProps.append("\(param.key) >= \(intValue)")
                case .lessOrEqualTo(let intValue):
                    searchProps.append("\(param.key) <= \(intValue)")
                }
            }
            let result = searchProps.joined(separator: " and ")
            return ["where" : result]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchAdvertisement:
            return .get
        }
    }
}
