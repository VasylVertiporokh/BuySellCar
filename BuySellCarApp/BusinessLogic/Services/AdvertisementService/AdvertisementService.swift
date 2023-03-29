//
//  AdvertisementService.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.03.2023.
//

import Foundation
import Combine

protocol AdvertisementService: AnyObject {
    var advertisementCountPublisher: AnyPublisher<AdvertisementCountResponseModel, Never> { get }
    
    func getAdvertisementObjects(pageSize: String) -> AnyPublisher<[AdvertisementResponseModel], NetworkError>
    func searchAdvertisement(searchParams: [SearchParam]) -> AnyPublisher<[AdvertisementResponseModel], NetworkError>
}
