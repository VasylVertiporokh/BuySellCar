//
//  AdvertisementEndpointBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 07.03.2023.
//

import Foundation

enum AdvertisementEndpointBuilder {
    case getAdvertisement(pageSize: String)
    case searchAdvertisement(SearchParamsDomainModel)
    case getAdvertisementCount([SearchParam])
    case getOwnAds(ownedId: String)
    case deleteAdvertisement(objectID: String)
    case getBrand
    case getModel(brandId: String)
}

// MARK: - EndpointBuilderProtocol
extension AdvertisementEndpointBuilder: EndpointBuilderProtocol {
    var path: String {
        switch self {
        case .searchAdvertisement, .getAdvertisement, .getOwnAds:
            return "/data/Advertisement"
        case .getAdvertisementCount:
            return "/data/Advertisement/count"
        case .deleteAdvertisement(objectID: let id):
            return "/data/Advertisement/\(id)"
        case .getBrand:
            return "/data/Brands"
        case .getModel:
            return "/data/Model"
        }
    }
    
    var headerFields: [String : String] {
        switch self {
        case .searchAdvertisement, .getAdvertisement, .getAdvertisementCount,
                .getOwnAds, .deleteAdvertisement, .getBrand, .getModel: // TODO: - Need plugin
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
            
        case .getOwnAds(let ownerID):
            return ["where" : "ownerId = '\(ownerID)'"] // TODO: - Fix
        
        case .deleteAdvertisement:
            return nil
        case .getBrand:
            return ["pageSize" : "100"]
        case .getModel(let brandId):
            return [
                "pageSize" : "100",
                "where" : "brandID = \(brandId)"
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchAdvertisement, .getAdvertisement, .getAdvertisementCount, .getOwnAds, .getBrand, .getModel:
            return .get
        case .deleteAdvertisement:
            return .delete
        }
    }
}
