//
//  AdvertisementNetworkService.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 07.03.2023.
//

import Foundation
import Combine

protocol AdvertisementNetworkService {
    func getAdvertisementObjects(pageSize: String) -> AnyPublisher<[AdvertisementResponseModel], NetworkError>
    func searchAdvertisement(searchParams: SearchParamsDomainModel) -> AnyPublisher<[AdvertisementResponseModel], NetworkError>
    func getAdvertisementCount(searchParams: [SearchParam]) -> AnyPublisher<Data, NetworkError>
    func getOwnAds(ownerID: String) -> AnyPublisher<[AdvertisementResponseModel], NetworkError>
    func deleteAdvertisement(objectID: String) -> AnyPublisher<Void, NetworkError>
    func getBrands() -> AnyPublisher<[BrandResponseModel], NetworkError>
    func getModelsByBrandId(_ brandId: String) -> AnyPublisher<[ModelResponseModel], NetworkError>
    func uploadAdvertisementImage(data: MultipartItem, userID: String) -> AnyPublisher<UploadingImageResponseModel, NetworkError>
    func publishAdvertisement(model: AddAdvertisementDomainModel) -> AnyPublisher<Void, NetworkError>
}
