//
//  AdvertisementService.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.03.2023.
//

import Foundation
import Combine

protocol AdvertisementService: AnyObject {
    var numberOfOwnAdsPublisher: AnyPublisher<Int, Never> { get }
    
    func getAdvertisementCount(searchParams: String) -> AnyPublisher<Data, Error>
    func searchAdvertisement(searchParams: AdsSearchModel) -> AnyPublisher<[AdvertisementDomainModel], Error>
    func getOwnAds(byID: String) -> AnyPublisher<[AdvertisementDomainModel], Error>
    func getBrands() -> AnyPublisher<[BrandDomainModel], Error>
    func getModelsByBrandId(_ brandId: String) -> AnyPublisher<[ModelsDomainModel], Error>
    func deleteAdvertisementByID(_ id: String) -> AnyPublisher<Void, Error>
    func uploadAdvertisementImage(item: MultipartItem, userID: String) -> AnyPublisher<UploadingImageResponseModel, Error>
    func publishAdvertisement(model: AddAdvertisementDomainModel, ownerId: String) -> AnyPublisher<Void, Error>
    func getRecommendationAdvertisement() -> AnyPublisher<RecommendationDomainModel, Error>
}
