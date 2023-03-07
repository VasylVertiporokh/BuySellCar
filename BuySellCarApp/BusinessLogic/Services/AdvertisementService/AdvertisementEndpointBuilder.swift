//
//  AdvertisementEndpointBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 07.03.2023.
//

import Foundation

enum AdvertisementEndpointBuilder {
   case searchAdvertisement(SearchAdvertisementQueryBuilder)
}

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
        case .searchAdvertisement(let searchAdvertisementQueryBuilder):
            return ["where" : searchAdvertisementQueryBuilder.searchQueryParam]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchAdvertisement:
            return .get
        }
    }
}
