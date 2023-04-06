//
//  AdvertisementServiceImpl.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.03.2023.
//

import Foundation
import Combine

final class AdvertisementServiceImpl {
    // MARK: - Internal properties
    private(set) lazy var advertisementCountPublisher = advertisementCountSubject.eraseToAnyPublisher()
    private(set) lazy var advertisementSearchParamsPublisher = searchParamsSubjects.eraseToAnyPublisher()
 
    // MARK: - Private properties
    private let advertisementNetworkService: AdvertisementNetworkService
    
    // MARK: - Subjects
    private let advertisementCountSubject = CurrentValueSubject<Int, Never>(0)
    private let searchParamsSubjects = CurrentValueSubject<SearchResultModel, Never>(.init())
    
    // MARK: - Init
    init(advertisementNetworkService: AdvertisementNetworkService) {
        self.advertisementNetworkService = advertisementNetworkService
    }
}

// MARK: - AdvertisementService
extension AdvertisementServiceImpl: AdvertisementService {
    func getAdvertisementCount(searchParams: [SearchParam]) -> AnyPublisher<Data, NetworkError> {
        advertisementNetworkService.getAdvertisementCount(searchParams: searchParams)
    }
    
    func getAdvertisementObjects(pageSize: String) -> AnyPublisher<[AdvertisementResponseModel], NetworkError> {
        advertisementNetworkService.getAdvertisementObjects(pageSize: pageSize)
    }
    
    func searchAdvertisement(searchParams: [SearchParam], pageSize: Int) -> AnyPublisher<[AdvertisementResponseModel], NetworkError> {
        advertisementNetworkService.searchAdvertisement(searchParams: searchParams, pageSize: pageSize)
    }
    
    func saveSearchParam(_ param: [SearchParam]) {
        searchParamsSubjects.value.searchParams = param
    }
    
    func deleteSearchParam(_ param: SearchParam) {
        searchParamsSubjects.value.searchParams.removeAll { $0 == param }
    }
    
    func addSearchParam(_ param: SearchParam) {
        searchParamsSubjects.value.searchParams.append(param)
    }
    
    func updatePageSize(_ size: Int) {
        searchParamsSubjects.value.defaultPageSize += size
    }
}
