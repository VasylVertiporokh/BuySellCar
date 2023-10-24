//
//  AdvertisementEndpointBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 07.03.2023.
//

import Foundation

enum AdvertisementEndpointBuilder {
    case getAdvertisement(pageSize: String)
    case searchAdvertisement(AdsSearchModel)
    case getAdvertisementCount(String)
    case getOwnAds(ownedId: String)
    case deleteAdvertisement(objectID: String)
    case getBrand
    case getModel(brandId: String)
    case uploadAdvertisementImage(item: MultipartItem, userId: String)
    case deleteImage(path: String)
    case editImageModel(images: EditImagesModel, objectId: String)
    case setAdsRelation(relationData: Data, createdObjectId: String)
    case publishAdvertisement(CreateAdvertisementRequestModel)
    case editAdvertisement(CreateAdvertisementRequestModel)
    case getTrandingCategories
}

// MARK: - EndpointBuilderProtocol
extension AdvertisementEndpointBuilder: EndpointBuilderProtocol {
    var path: String {
        switch self {
        case .searchAdvertisement, .getAdvertisement, .getOwnAds, .publishAdvertisement:
            return "/data/Advertisement"
            
        case .getAdvertisementCount:
            return "/data/Advertisement/count"
            
        case .deleteAdvertisement(objectID: let id):
            return "/data/Advertisement/\(id)"
            
        case .editImageModel(_ , let id):
            return "/data/Advertisement/\(id)"
            
        case .getBrand:
            return "/data/Brands"
            
        case .getModel:
            return "/data/Model"
            
        case .uploadAdvertisementImage(let dataItem, let userId):
            return "/files/images/users/\(userId)/\(dataItem.fileName)"
            
        case .deleteImage(let path):
            return "/files/images/users/\(path)"
            
        case .setAdsRelation(_, let ownerId):
            return "/data/Advertisement/\(ownerId)/userData"
            
        case .editAdvertisement(let adsModel):
            return "/data/Advertisement/\(adsModel.objectId)"
            
        case .getTrandingCategories:
            return "/files/fastSearch/trandingCategories"
        }
    }
    
    var query: [String : String]? {
        switch self {
        case .searchAdvertisement(let searchParams):
            return [
                "where" : searchParams.queryString,
                "pageSize" : "\(searchParams.pageSize)",
                "offset" : "\(searchParams.offset)",
                "loadRelations" : "userData"
            ]
            
        case.getAdvertisement(let pageSize):
            return pageSize.isEmpty ? nil : ["pageSize" : "\(pageSize)"]
            
        case .getAdvertisementCount(let searchParams):
            return ["where" : searchParams]
            
        case .getOwnAds(let ownerID):
            return [
                "where" : "ownerId = '\(ownerID)'",
                "loadRelations" : "userData",
                "pageSize" : "100",
            ]
            
        case .getBrand:
            return ["pageSize" : "100"]
            
        case .getModel(let brandId):
            return [
                "pageSize" : "100",
                "where" : "brandID = \(brandId)"
            ]
            
        default:
            return nil
        }
    }
    
    var body: RequestBody? {
        switch self {
        case .uploadAdvertisementImage(let item, _):       return .multipartBody([item])
        case .publishAdvertisement(let adsModel):          return .encodable(adsModel)
        case .setAdsRelation(let data, _):                 return .rawData(data)
        case .editImageModel(let model, _):                return .encodable(model)
        case .editAdvertisement(let model):                return .encodable(model)
            
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchAdvertisement, .getAdvertisement, .getAdvertisementCount, .getOwnAds, .getBrand, .getModel, .getTrandingCategories:
            return .get
            
        case .deleteAdvertisement, .deleteImage:
            return .delete
            
        case .uploadAdvertisementImage, .publishAdvertisement:
            return .post
            
        case .setAdsRelation:
            return .post
        
        case .editImageModel, .editAdvertisement:
            return .put
        }
    }
}
