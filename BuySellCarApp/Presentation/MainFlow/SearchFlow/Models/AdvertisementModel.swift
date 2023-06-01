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
    var brandModelPublisher: AnyPublisher<[ModelsDomainModel], Never> { get }
    var tempDomainModelPublisher: AnyPublisher<SearchAdvertismentDomainModel, Never> { get }
    
    func getRecommendedAdvertisements(searchModel: SearchParamsDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error>
    func findAdvertisements(searchModel: SearchParamsDomainModel) -> AnyPublisher<[AdvertisementDomainModel], Error>
    func getAdvertisementCount(searchParams: [SearchParam]) -> AnyPublisher<Int, Error>
    func loadNextPage()
    
    func setFastSearсhParams(_ param: [SearchParam])
    func deleteSearchParam(_ param: SearchParamsDomainModel)
    func resetSearchParams()
    func addSearchParam(_ param: SearchParam)
    func getAllBrands()
    func getBrandModels(id: String)
    func rangeValue(_ range: TechnicalSpecCellModel.SelectedRange, searchKey: SearchKey)
    
    
    
    func setBodyType(_ type: BodyTypeCellModel)
    func setFuelType(_ type: FuelTypeModel)
    func setTransmissionType(_ type: TransmissionTypeModel)
    func setBrand(_ brand: SelectedBrandModel)
    func setModel(_ model: ModelCellConfigurationModel)
    func deleteSelectedBrand(_ brand: SelectedBrandModel)
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
    lazy var brandModelPublisher = brandModelSubject.eraseToAnyPublisher()
    lazy var tempDomainModelPublisher = tempDomainModelSubject.eraseToAnyPublisher()
    
    // MARK: - Subjects
    private let modelErrorSubject = PassthroughSubject<Error, Never>()
    private let searchParamsSubjects = CurrentValueSubject<SearchParamsDomainModel, Never>(.init())
    private let brandsSubjects = CurrentValueSubject<[BrandDomainModel], Never>([])
    private let brandModelSubject = CurrentValueSubject<[ModelsDomainModel], Never>([])
    private let tempDomainModelSubject = CurrentValueSubject<SearchAdvertismentDomainModel, Never>(.init())
    
    // MARK: - Init
    init(advertisementService: AdvertisementService) {
        self.advertisementService = advertisementService
        getAllBrands()
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
        tempDomainModelSubject.value = .init()
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
            .receive(on: DispatchQueue.main)
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
    
    func getBrandModels(id: String) {
        advertisementService.getModelsByBrandId(id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.modelErrorSubject.send(error)
            } receiveValue: { [weak self] models in
                guard let self = self else {
                    return
                }
                self.brandModelSubject.send(models.sorted { $0.modelName < $1.modelName })
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
    
    func setModel(_ model: ModelCellConfigurationModel) {
        if !tempDomainModelSubject.value.selectedBrand.contains(where: { $0.id == model.brandID }) {
            guard let index = brandsSubjects.value.firstIndex(where: { $0.id == model.brandID }) else {
                return
            }
            brandsSubjects.value[index].isSelected = true
            let brand = brandsSubjects.value[index]
            tempDomainModelSubject.value.selectedBrand.append(.init(brand: brand.name, id: brand.id, model: model.modelName))
            addSearchParam(.init(key: .transportName, value: .equalToString(stringValue: brand.name)))
        } else {
            guard let index = tempDomainModelSubject.value.selectedBrand.firstIndex(where: { $0.id == model.brandID }) else {
                return
            }
            tempDomainModelSubject.value.selectedBrand[index].model = model.modelName
        }
    }
    
    func setBrand(_ brand: SelectedBrandModel) {
        guard let index = brandsSubjects.value.firstIndex(where: { $0.name == brand.brand }) else {
            return
        }
                
        guard !tempDomainModelSubject.value.selectedBrand.contains(where: { $0.brand == brand.brand }) else {
            brandsSubjects.value[index].isSelected = false
            tempDomainModelSubject.value.selectedBrand.removeAll { $0.brand == brand.brand }
            searchParamsSubjects.value.searchParams.removeAll { $0.value == .equalToString(stringValue: brand.brand) }
            return
        }
        
        brandsSubjects.value[index].isSelected = true
        tempDomainModelSubject.value.selectedBrand.append(brand)
        addSearchParam(.init(key: .transportName, value: .equalToString(stringValue: brand.brand)))
    }
    
    func setBodyType(_ type: BodyTypeCellModel) {
        guard let index = tempDomainModelSubject.value.bodyType.firstIndex(where: { $0.bodyTypeLabel == type.bodyTypeLabel }) else {
            return
        }
        tempDomainModelSubject.value.bodyType[index].isSelected.toggle()
        addSearchParam(.init(key: .bodyType, value: .equalToString(stringValue: type.bodyTypeLabel)))
    }
    
    func setFuelType(_ type: FuelTypeModel) {
        guard let index = tempDomainModelSubject.value.fuelType.firstIndex(where: { $0.fuelType == type.fuelType }) else {
            return
        }
        tempDomainModelSubject.value.fuelType[index].isSelected.toggle()
        addSearchParam(.init(key: .fuelType, value: .equalToString(stringValue: type.fuelType)))
    }
    
    func setTransmissionType(_ type: TransmissionTypeModel) {
        guard let index = tempDomainModelSubject.value.transmissionType.firstIndex(where: {
            $0.transmissionType == type.transmissionType }) else {
            return
        }
        tempDomainModelSubject.value.transmissionType[index].isSelected.toggle()
        addSearchParam(.init(key: .transmissionType, value: .equalToString(stringValue: type.transmissionType)))
    }
    
    func deleteSelectedBrand(_ brand: SelectedBrandModel) {
        tempDomainModelSubject.value.selectedBrand.removeAll { $0.brand == brand.brand }
        searchParamsSubjects.value.searchParams.removeAll { $0.value == .equalToString(stringValue: brand.brand) }
        if let selectedIndex = brandsSubjects.value.firstIndex(where: { $0.name == brand.brand }) {
            brandsSubjects.value[selectedIndex].isSelected = false
        }
    }
}

// MARK: - Constant
private enum Constant {
    static let nextPageSize: Int = 3
    static let countDefaultValue: Int = 0
}

struct SearchAdvertismentDomainModel {  // TODO: - Temp
    let basicBrand = BrandCellModel.basicBrands()
    var bodyType = BodyTypeCellModel.basicBodyTypes()
    var fuelType = FuelTypeModel.fuelTypes()
    var transmissionType = TransmissionTypeModel.transmissionTypes()
    var selectedBrand: [SelectedBrandModel] = []
}
