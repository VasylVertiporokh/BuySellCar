//
//  AdvertisementModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 06.04.2023.
//

import Foundation
import Combine

protocol AdvertisementModel {
    var advertisementSearchParamsPublisher: AnyPublisher<SearchResultDomainModel, Never> { get }
    
    func getRecommendedAdvertisements(searchModel: SearchResultDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error>
    func findAdvertisements(searchModel: SearchResultDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error>
    func getAdvertisementCount(searchParams: [SearchParam]) -> AnyPublisher<Int, Error>
    func loadNextPage()
    
    func setFastSearсhParams(_ param: [SearchParam])
    func deleteSearchParam(_ param: SearchResultDomainModel)
    func addSearchParam(_ param: SearchParam)
    func resetSearchParams()
}

final class AdvertisementModelImpl {
    // MARK: - Internal properties
    private(set) lazy var advertisementSearchParamsPublisher = searchParamsSubjects.eraseToAnyPublisher()
    
    // MARK: - Private properties
    private let advertisementService: AdvertisementService
    private var numberOfAdvertisements: Int = Constant.countDefaultValue
    
    // MARK: - Subjects
    private let searchParamsSubjects = CurrentValueSubject<SearchResultDomainModel, Never>(.init())
    
    // MARK: - Init
    init(advertisementService: AdvertisementService) {
        self.advertisementService = advertisementService
    }
}

// MARK: - AdvertisementModel protocol
extension AdvertisementModelImpl: AdvertisementModel {
    func getRecommendedAdvertisements(searchModel: SearchResultDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error> {
        advertisementService.searchAdvertisement(searchParams: searchModel)
    }
    
    func findAdvertisements(searchModel: SearchResultDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error> {
        advertisementService.searchAdvertisement(searchParams: searchModel)
    }
    
    func getAdvertisementCount(searchParams: [SearchParam]) -> AnyPublisher<Int, Error> {
        return advertisementService.getAdvertisementCount(searchParams: searchParams)
            .flatMap { [unowned self] addCount -> AnyPublisher<Int, Error> in
                let stringValue = String(data: addCount, encoding: .utf8) ?? "\(Constant.countDefaultValue)"
                numberOfAdvertisements = Int(stringValue) ?? Constant.countDefaultValue
                return Just(Int(stringValue))
                    .replaceNil(with: Constant.countDefaultValue)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func loadNextPage() {
        guard numberOfAdvertisements > searchParamsSubjects.value.offset + Constant.nextPageSize else {
            return
        }
        searchParamsSubjects.value.offset += Constant.nextPageSize
    }
    
    func setFastSearсhParams(_ param: [SearchParam]) {
        searchParamsSubjects.value.searchParams = param
    }
    
    func deleteSearchParam(_ param: SearchResultDomainModel) {
        searchParamsSubjects.value = param
    }
    
    func addSearchParam(_ param: SearchParam) {
        searchParamsSubjects.value.searchParams.append(param)
    }
    
    func resetSearchParams() {
        searchParamsSubjects.value = SearchResultDomainModel()
    }
}

// MARK: - Constant
private enum Constant {
    static let nextPageSize: Int = 3
    static let countDefaultValue: Int = 0
}
