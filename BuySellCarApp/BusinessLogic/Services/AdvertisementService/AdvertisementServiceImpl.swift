//
//  AdvertisementServiceImpl.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.03.2023.
//

import Foundation
import Combine

final class AdvertisementServiceImpl {
    // MARK: - Private properties
    private let advertisementNetworkService: AdvertisementNetworkService
    
    // MARK: - Publishers
    private(set) lazy var numberOfOwnAdsPublisher = numberOfOwnAdsSubject.eraseToAnyPublisher()
    private let numberOfOwnAdsSubject = CurrentValueSubject<Int, Never>(.zero)
    
    // MARK: - Init
    init(advertisementNetworkService: AdvertisementNetworkService) {
        self.advertisementNetworkService = advertisementNetworkService
    }
}

// MARK: - AdvertisementService
extension AdvertisementServiceImpl: AdvertisementService {
    func getAdvertisementCount(searchParams: String) -> AnyPublisher<Data, Error> {
        advertisementNetworkService.getAdvertisementCount(searchParams: searchParams)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func searchAdvertisement(searchParams: AdsSearchModel) -> AnyPublisher<[AdvertisementDomainModel], Error> {
        advertisementNetworkService.searchAdvertisement(searchParams: searchParams)
            .mapError { $0 as Error }
            .map { $0.map { AdvertisementDomainModel(advertisementResponseModel: $0) } }
            .eraseToAnyPublisher()
    }
    
    func getOwnAds(byID: String) -> AnyPublisher<[AdvertisementDomainModel], Error> {
        advertisementNetworkService.getOwnAds(ownerID: byID)
            .mapError { $0 as Error }
            .map { $0.map { AdvertisementDomainModel(advertisementResponseModel: $0) } }
            .handleEvents(receiveOutput: { [unowned self] adsCount in
                numberOfOwnAdsSubject.send(adsCount.count)
            })
            .eraseToAnyPublisher()
    }
    
    func getBrands() -> AnyPublisher<[BrandDomainModel], Error> {
        advertisementNetworkService.getBrands()
            .mapError { $0 as Error }
            .map { $0.map { BrandDomainModel(brandResponseModel: $0) }}
            .eraseToAnyPublisher()
    }
    
    func getModelsByBrandId(_ brandId: String) -> AnyPublisher<[ModelsDomainModel], Error> {
        advertisementNetworkService.getModelsByBrandId(brandId)
            .mapError { $0 as Error }
            .map { $0.map { ModelsDomainModel(modelResponseModel: $0) }}
            .eraseToAnyPublisher()
    }
    
    func deleteAdvertisementByID(_ id: String) -> AnyPublisher<Void, Error> {
        advertisementNetworkService.deleteAdvertisement(objectID: id)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func uploadAdvertisementImage(item: MultipartItem, userID: String) -> AnyPublisher<UploadingImageResponseModel, Error> {
        advertisementNetworkService.uploadAdvertisementImage(data: item, userID: userID)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func publishAdvertisement(model: AddAdvertisementDomainModel, ownerId: String) -> AnyPublisher<Void, Error> {
        advertisementNetworkService.publishAdvertisement(model: model)
            .mapError { $0 as Error }
            .flatMap { [unowned self] model -> AnyPublisher<Void, Error> in
                return advertisementNetworkService.setAdsRelation(ownerId: ownerId, publishedResponse: model)
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func updateAdvertisement(model: AddAdvertisementDomainModel) -> AnyPublisher<Void, Error> {
        advertisementNetworkService.updateAdvertisement(model: model)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func getRecommendationAdvertisement() -> AnyPublisher<RecommendationDomainModel, Error> {
        let defaultModel = Constant.defaultModel
        return advertisementNetworkService.searchAdvertisement(searchParams: defaultModel)
            .combineLatest(advertisementNetworkService.getTrandingCategories())
            .map { (ads, categories) -> RecommendationDomainModel in
                return .init(
                    recommendationAds: ads.map { .init(advertisementResponseModel: $0) },
                    trendingCategories: categories.map { .init(trandingResponseModel: $0) })
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func deleteRemoteImage(
        imageModel: EditImagesModel,
        imageUrl: String,
        id: String?
    ) -> AnyPublisher<EditImagesModel?, Error> {
        guard let imagePath = imageUrl.components(separatedBy: "users/").last,
              let id = id else {
            return Fail(error: NetworkError.badURLError)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        }
        
        return advertisementNetworkService.deleteImage(url: imagePath)
            .mapError { $0 as Error }
            .flatMap { [unowned self] _ -> AnyPublisher<EditImagesModel?, Error> in
                return advertisementNetworkService.deleteImageFromUserAds(imagesModel: imageModel, id: id)
                    .map { .init(adsImages: $0?.adsImages) }
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Constant
private enum Constant {
    static let defaultModel: AdsSearchModel = .init(pageSize: 15, offset: 0)
}
