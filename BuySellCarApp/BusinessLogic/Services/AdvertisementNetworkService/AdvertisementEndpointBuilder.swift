//
//  AdvertisementEndpointBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 07.03.2023.
//

import Foundation

enum AdvertisementEndpointBuilder {
    case getAdvertisement(pageSize: String)
    case searchAdvertisement(SearchResultDomainModel)
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
            return ["Content-Type" : "application/json"]
        }
    }
    
    var query: [String : String]? {
        switch self {
        case .searchAdvertisement(let searchParams):
            let query = searchParams.searchParams
                .map { $0.queryString }
                .joined(separator: " and ")
            return [
                "where" : query,
                "pageSize" : "\(searchParams.pageSize)",
                "offset" : "\(searchParams.offset)"
            ]
            
        case.getAdvertisement(let pageSize):
            return pageSize.isEmpty ? nil : ["pageSize" : "\(pageSize)"]
            
        case .getAdvertisementCount(let searchParams):
            let query = searchParams
                .map { $0.queryString }
                .joined(separator: " and ")
            return ["where" : query]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchAdvertisement, .getAdvertisement, .getAdvertisementCount:
            return .get
        }
    }
}
