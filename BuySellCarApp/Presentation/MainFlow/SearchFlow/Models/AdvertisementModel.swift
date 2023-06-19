//
//  AdvertisementModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 06.04.2023.
//

import Foundation
import Combine

// MARK: - RangeParametersType
enum RangeParametersType {
    case registration
    case millage
    case power
}

protocol AdvertisementModel {
    var modelErrorPublisher: AnyPublisher<Error, Never> { get }
    var tempDomainModelPublisher: AnyPublisher<FilterDomainModel, Never> { get }
    var searchModelPublisher: AnyPublisher<AdsSearchModel, Never> { get }
    var numberOfAdvertisementsPublisher: AnyPublisher<Int, Never> { get }
    var advertisementPublisher: AnyPublisher<[AdvertisementDomainModel]?, Never> { get }
    var updatingInProgressPublisher: AnyPublisher<Void, Never> { get }
    
    func getRecommendedAdvertisements(searchModel: AdsSearchModel) -> AnyPublisher<[AdvertisementDomainModel], Error>
    func findAdvertisements(searchModel: AdsSearchModel)
    func getAdvertisementCount(searchParams: String)
    func loadNextPage()
    
    func setFastSearсhParams(_ param: [SearchParam])
    func resetSearchParams()
    func getAllBrands()
    func getBrandModels(id: String)
    func rangeValue(_ range: TechnicalSpecCellModel.SelectedRange, _ type: RangeParametersType)
    
    func setBodyType(_ type: BodyTypeModel)
    func setFuelType(_ type: FuelTypeModel)
    func setTransmissionType(_ type: TransmissionTypeModel)
    func setBrand(_ brand: SelectedBrandModel)
    func setModel(_ model: ModelCellConfigurationModel)
    func deleteSelectedBrand(_ brand: SelectedBrandModel)
    func deleteRangeParams(param: SearchParam, type: RangeParametersType)
}

final class AdvertisementModelImpl {
    // MARK: - Private properties
    private let advertisementService: AdvertisementService
    private var numberOfAdvertisements: Int = Constant.countDefaultValue
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Publishers
    lazy var modelErrorPublisher = modelErrorSubject.eraseToAnyPublisher()
    lazy var tempDomainModelPublisher = searchDomainModel.eraseToAnyPublisher()
    lazy var searchModelPublisher = searchModelSubject.eraseToAnyPublisher()
    lazy var numberOfAdvertisementsPublisher = numberOfAdvertisementsSubject.eraseToAnyPublisher()
    lazy var advertisementPublisher = advertisementSubject.eraseToAnyPublisher()
    lazy var updatingInProgressPublisher = updatingInProgressSubject.eraseToAnyPublisher()
    
    // MARK: - Subjects
    private let modelErrorSubject = PassthroughSubject<Error, Never>()
    private let searchDomainModel = CurrentValueSubject<FilterDomainModel, Never>(.init())
    private let searchModelSubject = CurrentValueSubject<AdsSearchModel, Never>(.init())
    private let numberOfAdvertisementsSubject = CurrentValueSubject<Int, Never>(Constant.countDefaultValue)
    private let advertisementSubject = CurrentValueSubject<[AdvertisementDomainModel]?, Never>(nil)
    private let updatingInProgressSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(advertisementService: AdvertisementService) {
        self.advertisementService = advertisementService
        getAllBrands()
        
        searchModelSubject
            .sink { [unowned self] model in
                getAdvertisementCount(searchParams: model.queryString)
                findAdvertisements(searchModel: model)
            }
            .store(in: &cancellables)
    }
}

// MARK: - AdvertisementModel protocol
extension AdvertisementModelImpl: AdvertisementModel {
    func getRecommendedAdvertisements(searchModel: AdsSearchModel) -> AnyPublisher<[AdvertisementDomainModel], Error> {
        advertisementService.searchAdvertisement(searchParams: searchModel)
    }
    
    func findAdvertisements(searchModel: AdsSearchModel) {
        advertisementService.searchAdvertisement(searchParams: searchModel)
            .sink {  [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.modelErrorSubject.send(error)
            } receiveValue: { [weak self] adsModel in
                guard let self = self else { return }
                self.advertisementSubject.value = adsModel
            }
            .store(in: &cancellables)
        
    }
    
    func getAdvertisementCount(searchParams: String) {
        advertisementService.getAdvertisementCount(searchParams: searchParams)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.modelErrorSubject.send(error)
            } receiveValue: { [weak self] data in
                guard let self = self else {
                    return
                }
                let stringValue = String(data: data, encoding: .utf8) ?? "\(Constant.countDefaultValue)"
                self.numberOfAdvertisementsSubject.send(Int(stringValue) ?? Constant.countDefaultValue)
            }
            .store(in: &cancellables)
    }
    
    func loadNextPage() {
        guard numberOfAdvertisementsSubject.value > searchModelSubject.value.offset + Constant.nextPageSize else {
            return
        }
        searchModelSubject.value.offset += Constant.nextPageSize
    }
    
    func setFastSearсhParams(_ param: [SearchParam]) {
        
    }
    
    func resetSearchParams() {
        searchDomainModel.value = .init()
        generateQueryString()
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
                self.searchDomainModel.value.allBrands = brandModel.sorted { $0.name < $1.name }
            }
            .store(in: &cancellables)
    }
    
    func getBrandModels(id: String) {
        guard !searchDomainModel.value.brandModels.contains(where: { $0.brandID == id }) else {
            return
        }
        
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
                self.searchDomainModel.value.brandModels = models.sorted { $0.modelName < $1.modelName }
            }
            .store(in: &cancellables)
    }
    
    func rangeValue(_ range: TechnicalSpecCellModel.SelectedRange, _ type: RangeParametersType) {
        switch type {
        case .registration:
            searchDomainModel.value.year.minSelected = range.minRangeValue
            searchDomainModel.value.year.maxSelected = range.maxRangeValue
            
        case .millage:
            searchDomainModel.value.millage.minSelected = range.minRangeValue
            searchDomainModel.value.millage.maxSelected = range.maxRangeValue
            
        case .power:
            searchDomainModel.value.power.minSelected = range.minRangeValue
            searchDomainModel.value.power.maxSelected = range.maxRangeValue
        }
        generateQueryString()
    }
    
    func setModel(_ model: ModelCellConfigurationModel) {
        // get selected index
        guard let tappedCellIndex = searchDomainModel.value.brandModels.firstIndex(where: { $0.modelName == model.modelName }) else {
            return
        }
        
        // perform last
        defer {
            generateQueryString()
            searchDomainModel.value.brandModels[tappedCellIndex].isSelected.toggle()
        }
        
        // create new brand if selected brand is empty
        guard let brandIndex = searchDomainModel.value.selectedBrand.firstIndex(where: { $0.id == model.brandID }) else {
            if let brand = searchDomainModel.value.allBrands.first(where: { $0.id == model.brandID }) {
                let selectedBrand = SelectedBrandModel(
                    id: brand.id,
                    brand: brand.name,
                    model: [model.modelName],
                    isSelected: true,
                    brandModelSearchParams: [model.searchParam]
                )
                searchDomainModel.value.selectedBrand.append(selectedBrand)
            }
            return
        }
        
        //  delete the model if it already exists
        guard !searchDomainModel.value.selectedBrand[brandIndex].model.contains(model.modelName) else {
            searchDomainModel.value.selectedBrand[brandIndex].brandModelSearchParams.removeAll { $0 == model.searchParam }
            searchDomainModel.value.selectedBrand[brandIndex].model.removeAll { $0 == model.modelName }
            return
        }
        
        // add new model to selected brand
        searchDomainModel.value.selectedBrand[brandIndex].brandModelSearchParams.append(model.searchParam)
        searchDomainModel.value.selectedBrand[brandIndex].model.append(model.modelName)
    }
    
    func setBrand(_ brand: SelectedBrandModel) {
        searchDomainModel.value.selectedBrand.append(brand)
        generateQueryString()
    }
    
    func setBodyType(_ type: BodyTypeModel) {
        guard let index = searchDomainModel.value.bodyType.firstIndex(where: { $0 == type }) else {
            return
        }
        searchDomainModel.value.bodyType[index].isSelected.toggle()
        generateQueryString()
    }
    
    func setFuelType(_ type: FuelTypeModel) {
        guard let index = searchDomainModel.value.fuelType.firstIndex(where: { $0 == type }) else {
            return
        }
        searchDomainModel.value.fuelType[index].isSelected.toggle()
        generateQueryString()
    }
    
    func setTransmissionType(_ type: TransmissionTypeModel) {
        guard let index = searchDomainModel.value.transmissionType.firstIndex(where: { $0 == type }) else {
            return
        }
        
        searchDomainModel.value.transmissionType[index].isSelected.toggle()
        generateQueryString()
    }
    
    func deleteSelectedBrand(_ brand: SelectedBrandModel) {
        searchDomainModel.value.selectedBrand.removeAll()
        searchDomainModel.value.brandModels.removeAll()
        generateQueryString()
    }
    
    func deleteRangeParams(param: SearchParam, type: RangeParametersType) {
        switch type {
        case .registration:
            let isMinValue = searchDomainModel.value.year.minSearchValue?.value == param.value
            isMinValue ? (searchDomainModel.value.year.minSelected = nil) : (searchDomainModel.value.year.maxSelected = nil)
            
        case .power:
            let isMinValue = searchDomainModel.value.power.minSearchValue?.value == param.value
            isMinValue ? (searchDomainModel.value.power.minSelected = nil) : (searchDomainModel.value.power.maxSelected = nil)
            
        case .millage:
            let isMinValue = searchDomainModel.value.millage.minSearchValue?.value == param.value
            isMinValue ? (searchDomainModel.value.millage.minSelected = nil) : (searchDomainModel.value.millage.maxSelected = nil)
        }
        generateQueryString()
    }
}

// MARK: - Private extension
private extension AdvertisementModelImpl {
    func generateQueryString() {
        updatingInProgressSubject.send()
        let body: [SearchParam] = searchDomainModel.value.bodyType
            .filter { $0.isSelected }
            .map { $0.searchParam }
        
        let fuel: [SearchParam] = searchDomainModel.value.fuelType
            .filter { $0.isSelected }
            .map { $0.searchParam }
        
        let transmission: [SearchParam] = searchDomainModel.value.transmissionType
            .filter { $0.isSelected }
            .map { $0.searchParam }
        
        let brand: [SearchParam] = searchDomainModel.value.selectedBrand
            .filter { $0.isSelected }
            .map { $0.searchParam }
        
        let model: [SearchParam] = searchDomainModel.value.selectedBrand
            .flatMap { $0.brandModelSearchParams }
        
        let paramsArray: [[SearchParam]] = [brand, model, body, fuel, transmission]
        
        let rangeParams: [String] = [
            searchDomainModel.value.year.minSearchValue,
            searchDomainModel.value.year.maxSearchValue,
            searchDomainModel.value.millage.minSearchValue,
            searchDomainModel.value.millage.maxSearchValue,
            searchDomainModel.value.power.minSearchValue,
            searchDomainModel.value.power.maxSearchValue
        ]
            .compactMap { $0 }
            .map { $0.queryString }
        
        var joinedParams: [String] = paramsArray.map { params in
            let joinedString = params.map { $0.queryString }.joined(separator: " or ")
            return params.isEmpty ? joinedString : "(\(joinedString))"
        }
        
        joinedParams.append(contentsOf: rangeParams)
        
        let queryString = joinedParams.filter { !$0.isEmpty }.joined(separator: " and ")
        searchModelSubject.value = .init(queryString: queryString)
    }
}

// MARK: - Constant
private enum Constant {
    static let nextPageSize: Int = 3
    static let countDefaultValue: Int = 0
}

struct AdsSearchModel {
    var queryString: String = ""
    var pageSize: Int = 3
    var offset: Int = 0
}
