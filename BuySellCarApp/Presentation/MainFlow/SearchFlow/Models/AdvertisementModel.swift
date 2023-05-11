//
//  AdvertisementModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 06.04.2023.
//

import Foundation
import Combine

protocol AdvertisementModel {
    var advertisementSearchParamsPublisher: AnyPublisher<SearchParamsDomainModel, Never> { get }
    
    func getRecommendedAdvertisements(searchModel: SearchParamsDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error>
    func findAdvertisements(searchModel: SearchParamsDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error>
    func getAdvertisementCount(searchParams: [SearchParam]) -> AnyPublisher<Int, Error>
    func loadNextPage()
    
    func setFastSearсhParams(_ param: [SearchParam])
    func deleteSearchParam(_ param: SearchParamsDomainModel)
    func resetSearchParams()
    func addSearchParam(_ param: SearchParam)
    func rangeValue(_ range: TechnicalSpecCellModel.SelectedRange, searchKey: SearchKey)
}

final class AdvertisementModelImpl {
    // MARK: - Internal properties
    private(set) lazy var advertisementSearchParamsPublisher = searchParamsSubjects.eraseToAnyPublisher()
    
    // MARK: - Private properties
    private let advertisementService: AdvertisementService
    private var numberOfAdvertisements: Int = Constant.countDefaultValue
    
    // MARK: - Subjects
    private let searchParamsSubjects = CurrentValueSubject<SearchParamsDomainModel, Never>(.init())
    
    // MARK: - Init
    init(advertisementService: AdvertisementService) {
        self.advertisementService = advertisementService
    }
}

// MARK: - AdvertisementModel protocol
extension AdvertisementModelImpl: AdvertisementModel {
    func getRecommendedAdvertisements(searchModel: SearchParamsDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error> {
        advertisementService.searchAdvertisement(searchParams: searchModel)
    }
    
    func findAdvertisements(searchModel: SearchParamsDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error> {
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
    
    func deleteSearchParam(_ param: SearchParamsDomainModel) {
        searchParamsSubjects.value = param
    }
    
    func resetSearchParams() {
        searchParamsSubjects.value = SearchParamsDomainModel()
    }
    
    func addSearchParam(_ param: SearchParam) {
        guard searchParamsSubjects.value.searchParams.contains(where: { $0 == param }) else {
            searchParamsSubjects.value.searchParams.append(param)
            return
        }
        searchParamsSubjects.value.searchParams.removeAll { $0 == param }
    }
    
    func rangeValue(_ range: TechnicalSpecCellModel.SelectedRange, searchKey: SearchKey) {
        if let max = range.maxRangeValue {
            let maxSearchParams = SearchParam(key: searchKey, value: .lessOrEqualTo(intValue: Int(max)), valueType: .max)
            if let index = searchParamsSubjects.value.searchParams.firstIndex(where: {
                $0.key == maxSearchParams.key && $0.valueType == maxSearchParams.valueType
            }) {
                searchParamsSubjects.value.searchParams[index].value = maxSearchParams.value
            } else {
                searchParamsSubjects.value.searchParams.append(maxSearchParams)
            }
        } else {
            searchParamsSubjects.value.searchParams.removeAll { $0.key == searchKey && $0.valueType == .max }
        }
        
        if let min = range.minRangeValue {
            let minSearchParams = SearchParam(key: searchKey, value: .greaterOrEqualTo(intValue: Int(min)), valueType: .min)
            if let index = searchParamsSubjects.value.searchParams.firstIndex(where: {
                $0.key == minSearchParams.key && $0.valueType == minSearchParams.valueType }) {
                searchParamsSubjects.value.searchParams[index].value = minSearchParams.value
            } else {
                searchParamsSubjects.value.searchParams.append(minSearchParams)
            }
        } else {
            searchParamsSubjects.value.searchParams.removeAll { $0.key == searchKey && $0.valueType == .min }
        }
    }
}

// MARK: - Constant
private enum Constant {
    static let nextPageSize: Int = 3
    static let countDefaultValue: Int = 0
}
