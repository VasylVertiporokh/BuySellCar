//
//  AdvertisementEndpointBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 07.03.2023.
//

import Foundation

enum AdvertisementEndpointBuilder {
    case getAdvertisement(pageSize: String)
    case searchAdvertisement([SearchParam])
    case getAdvertisementCount([SearchParam])
}

// MARK: - EndpointBuilderProtocol
extension AdvertisementEndpointBuilder: EndpointBuilderProtocol {
    var path: String {
        switch self {
        case .searchAdvertisement, .getAdvertisement:
            return "/data/Advertisement"
        case .getAdvertisementCount:
            return "/data/Advertisement/count"
        }
    }
    
    var headerFields: [String : String] {
        switch self {
        case .searchAdvertisement, .getAdvertisement, .getAdvertisementCount:
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
        case.getAdvertisement(let pageSize):
            return pageSize.isEmpty ? nil : ["pageSize" : "\(pageSize)"]
        case .getAdvertisementCount(let searchParams):
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
        case .searchAdvertisement, .getAdvertisement, .getAdvertisementCount:
            return .get
        }
    }
}
