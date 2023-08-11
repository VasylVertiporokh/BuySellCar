//
//  AdvertisementNetworkImpl.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 07.03.2023.
//

import Foundation
import Combine

final class AdvertisementNetworkImpl<NetworkProvider: NetworkProviderProtocol> where NetworkProvider.Endpoint == AdvertisementEndpointBuilder {
    // MARK: - Private properties
    private let provider: NetworkProvider
    
    // MARK: - Init
    init(provider: NetworkProvider) {
        self.provider = provider
    }
}

// MARK: - AdvertisementNetworkService
extension AdvertisementNetworkImpl: AdvertisementNetworkService {
    func getAdvertisementObjects(pageSize: String) -> AnyPublisher<[AdvertisementResponseModel], NetworkError> {
        provider.performWithResponseModel(.getAdvertisement(pageSize: pageSize))
    }
    
    func searchAdvertisement(searchParams: AdsSearchModel) -> AnyPublisher<[AdvertisementResponseModel], NetworkError> {
        provider.performWithResponseModel(.searchAdvertisement(searchParams))
    }
    
    func getAdvertisementCount(searchParams: String) -> AnyPublisher<Data, NetworkError> {
        provider.performWithRawData(.getAdvertisementCount(searchParams))
    }
    
    func getOwnAds(ownerID: String) -> AnyPublisher<[AdvertisementResponseModel], NetworkError> {
        provider.performWithResponseModel(.getOwnAds(ownedId: ownerID))
    }
    
    func deleteAdvertisement(objectID: String) -> AnyPublisher<Void, NetworkError> {
        provider.performWithProcessingResult(.deleteAdvertisement(objectID: objectID))
    }
    
    func getBrands() -> AnyPublisher<[BrandResponseModel], NetworkError> {
        provider.performWithResponseModel(.getBrand)
    }
    
    func getModelsByBrandId(_ brandId: String) -> AnyPublisher<[ModelResponseModel], NetworkError> {
        provider.performWithResponseModel(.getModel(brandId: brandId))
    }
    
    func uploadAdvertisementImage(data: MultipartItem, userID: String) -> AnyPublisher<UploadingImageResponseModel, NetworkError> {
        provider.performWithResponseModel(.uploadAdvertisementImage(item: data, userId: userID))
    }
    
    func publishAdvertisement(model: AddAdvertisementDomainModel) -> AnyPublisher<AdsPublishResponseModel, NetworkError> {
        provider.performWithResponseModel(.publishAdvertisement(.init(domainModel: model)))
    }
    
    func setAdsRrelation(ownerId: String, publishedResponse: AdsPublishResponseModel) -> AnyPublisher<Void, NetworkError> {
        let ownerData: [String] = [ownerId]
        do {
            let data = try JSONSerialization.data(withJSONObject: ownerData, options: [])
               return provider.performWithProcessingResult(.setAdsRelation(
                   relationData: data,
                   createdObjectId: publishedResponse.objectId)
               )
            
        } catch {
            return Fail(error: NetworkError.unexpectedError)
                .eraseToAnyPublisher()
        }
    }
    
    func getTrandingCategories() -> AnyPublisher<[TrandingCategoriesResponseModel], NetworkError> {
        provider.performWithResponseModel(.getTrandingCategories)
    }
}
