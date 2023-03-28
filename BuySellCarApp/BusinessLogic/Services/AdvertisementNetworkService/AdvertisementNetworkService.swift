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
    func searchAdvertisement(searchParams: [SearchParam]) -> AnyPublisher<[AdvertisementResponseModel], NetworkError>
}
