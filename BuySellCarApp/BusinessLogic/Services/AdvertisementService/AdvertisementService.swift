//
//  AdvertisementService.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.03.2023.
//

import Foundation
import Combine

protocol AdvertisementService: AnyObject {
    func getAdvertisementCount(searchParams: [SearchParam]) -> AnyPublisher<Data, Error>
    func searchAdvertisement(searchParams: SearchParamsDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error>
    func getOwnAds(byID: String) -> AnyPublisher<[AdvertisementDomainModel], Error>
    func getBrands() -> AnyPublisher<[BrandDomainModel], Error>
    func getModelsByBrandId(_ brandId: String) -> AnyPublisher<[ModelsDomainModel], Error>
    func deleteAdvertisementByID(_ id: String) -> AnyPublisher<Void, Error>
}
