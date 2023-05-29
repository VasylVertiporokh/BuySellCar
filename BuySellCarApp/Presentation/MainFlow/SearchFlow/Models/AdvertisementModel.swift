//
//  AdvertisementModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 06.04.2023.
//

import Foundation
import Combine

protocol AdvertisementModel {
    var modelErrorPublisher: AnyPublisher<Error, Never> { get }
    var advertisementSearchParamsPublisher: AnyPublisher<SearchParamsDomainModel, Never> { get }
    var brandsPublisher: AnyPublisher<[BrandDomainModel], Never> { get }
    
    func getRecommendedAdvertisements(searchModel: SearchParamsDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error>
    func findAdvertisements(searchModel: SearchParamsDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error>
    func getAdvertisementCount(searchParams: [SearchParam]) -> AnyPublisher<Int, Error>
    func loadNextPage()
    
    func setFastSearсhParams(_ param: [SearchParam])
    func deleteSearchParam(_ param: SearchParamsDomainModel)
    func resetSearchParams()
    func addSearchParam(_ param: SearchParam)
    func getAllBrands()
    func rangeValue(_ range: TechnicalSpecCellModel.SelectedRange, searchKey: SearchKey)
}

final class AdvertisementModelImpl {
    // MARK: - Private properties
    private let advertisementService: AdvertisementService
    private var numberOfAdvertisements: Int = Constant.countDefaultValue
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Publishers
    lazy var modelErrorPublisher = modelErrorSubject.eraseToAnyPublisher()
    lazy var advertisementSearchParamsPublisher = searchParamsSubjects.eraseToAnyPublisher()
    lazy var brandsPublisher = brandsSubjects.eraseToAnyPublisher()
    
    // MARK: - Subjects
    private let modelErrorSubject = PassthroughSubject<Error, Never>()
    private let searchParamsSubjects = CurrentValueSubject<SearchParamsDomainModel, Never>(.init())
    private let brandsSubjects = CurrentValueSubject<[BrandDomainModel], Never>([])
    
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
    
    func getAllBrands() {
        advertisementService.getBrands()
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.modelErrorSubject.send(error)
            } receiveValue: { [weak self] brandModel in
                guard let self = self else {
                    return
                }
                self.brandsSubjects.send(brandModel.sorted { $0.name < $1.name })
            }
            .store(in: &cancellables)
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


struct TestDomainModel {
    var basicBrand = BrandCellModel.basicBrands()
    var bodyType = BodyTypeCellModel.basicBodyTypes()
    var fuelType = FuelTypeModel.fuelTypes()
    var transmissionType = TransmissionTypeModel.transmissionTypes()
    var selectedBrand: [SelectedBrandModel] = []
//    var year = TechnicalSpecCellModel.year(selectedRange: selectedYearRangeSubject)
//    var millage = TechnicalSpecCellModel.millage(selectedRange: millageSelectedRangeSubject)
//    var power = TechnicalSpecCellModel.power(selectedRange: powerSelectedRangeSubject)
}
