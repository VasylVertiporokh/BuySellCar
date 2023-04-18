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
    func searchAdvertisement(searchParams: SearchResultDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error>
}
