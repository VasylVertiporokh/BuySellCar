//
//  AdvertisementService.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.03.2023.
//

import Foundation
import Combine

protocol AdvertisementService: AnyObject {
    var advertisementCountPublisher: AnyPublisher<Int, Never> { get }
    var advertisementSearchParamsPublisher: AnyPublisher<SearchResultModel, Never> { get }
    
    func saveSearchParam(_ param: [SearchParam])
    func deleteSearchParam(_ param: SearchParam)
    func addSearchParam(_ param: SearchParam)
    
    func getAdvertisementObjects(pageSize: String) -> AnyPublisher<[AdvertisementResponseModel], NetworkError>
    func getAdvertisementCount(searchParams: [SearchParam]) -> AnyPublisher<Data, NetworkError >
    func searchAdvertisement(searchParams: [SearchParam], pageSize: Int) -> AnyPublisher<[AdvertisementResponseModel], NetworkError>
    
    func updatePageSize(_ size: Int)
}
