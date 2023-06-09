//
//  AdvertisementModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 06.04.2023.
//

import Foundation
import Combine

enum RangeParametersType {
    case registration
    case millage
    case power
}

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
    func rangeValue(_ range: TechnicalSpecCellModel.SelectedRange, _ type: RangeParametersType)
    
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
    lazy var tempDomainModelPublisher = searchDomainModel.eraseToAnyPublisher()
    
    // MARK: - Subjects
    private let modelErrorSubject = PassthroughSubject<Error, Never>()
    private let searchParamsSubjects = CurrentValueSubject<SearchParamsDomainModel, Never>(.init())
    private let brandsSubjects = CurrentValueSubject<[BrandDomainModel], Never>([])
    private let brandModelSubject = CurrentValueSubject<[ModelsDomainModel], Never>([])
    private let searchDomainModel = CurrentValueSubject<SearchAdvertismentDomainModel, Never>(.init())
    
    private let testSearchModelSubject = CurrentValueSubject<SearchTestModel, Never>(.init())
    
    // MARK: - Init
    init(advertisementService: AdvertisementService) {
        self.advertisementService = advertisementService
        getAllBrands()
        
        testSearchModelSubject
            .sink { [unowned self] model in
                print("STRING \(model.queryString)")
            }
            .store(in: &cancellables)
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
        searchDomainModel.value = .init()
        searchParamsSubjects.value = SearchParamsDomainModel()
    }
    
    func addSearchParam(_ param: SearchParam) {
        guard searchParamsSubjects.value.searchParams.contains(param) else {
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
        guard !brandModelSubject.value.contains(where: { $0.brandID == id }) else {
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
                self.brandModelSubject.send(models.sorted { $0.modelName < $1.modelName })
            }
            .store(in: &cancellables)
    }
    
    func rangeValue(_ range: TechnicalSpecCellModel.SelectedRange, _ type: RangeParametersType) {
        switch type {
        case .registration:
            searchDomainModel.value.minYearSearchParam = range.minRangeValue.map { min in
                    .init(key: .yearOfManufacture, value: .greaterOrEqualTo(intValue: Int(min)))
            }
            
            searchDomainModel.value.maxYearSearchParam = range.maxRangeValue.map { max in
                    .init(key: .yearOfManufacture, value: .lessOrEqualTo(intValue: Int(max)))
            }
            
        case .millage:
            searchDomainModel.value.minMillageSearchParam = range.minRangeValue.map { min in
                    .init(key: .mileage, value: .greaterOrEqualTo(intValue: Int(min)))
            }
            
            searchDomainModel.value.maxMillageSearchParam = range.maxRangeValue.map { max in
                    .init(key: .mileage, value: .lessOrEqualTo(intValue: Int(max)))
            }
            
        case .power:
            searchDomainModel.value.minPowerSearchParam = range.minRangeValue.map { min in
                    .init(key: .power, value: .greaterOrEqualTo(intValue: Int(min)))
            }
            
            searchDomainModel.value.maxPowerSearchParam = range.maxRangeValue.map { max in
                    .init(key: .power, value: .lessOrEqualTo(intValue: Int(max)))
            }
        }
        
        generateQueryString()
    }
    
    func setModel(_ model: ModelCellConfigurationModel) {
        // get selected index
        guard let tappedCellIndex = brandModelSubject.value.firstIndex(where: { $0.modelName == model.modelName }) else {
            return
        }
        
        // perform last
        defer {
            generateQueryString()
            brandModelSubject.value[tappedCellIndex].isSelected.toggle()
        }
        
        // create new brand if selected brand is empty
        guard let brandIndex = searchDomainModel.value.selectedBrand.firstIndex(where: { $0.id == model.brandID }) else {
            if let brand = brandsSubjects.value.first(where: { $0.id == model.brandID }) {
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
    
    func setBodyType(_ type: BodyTypeCellModel) {
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
        brandModelSubject.value.removeAll()
        generateQueryString()
    }
}

// MARK: - Private extension
private extension AdvertisementModelImpl {
    func generateQueryString() {
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
        
        let paramsArray: [[SearchParam]] = [body, fuel, transmission, brand, model]
        
        let rangeParams: [String] = [
            searchDomainModel.value.minPowerSearchParam,
            searchDomainModel.value.maxPowerSearchParam,
            searchDomainModel.value.minYearSearchParam,
            searchDomainModel.value.maxYearSearchParam,
            searchDomainModel.value.minMillageSearchParam,
            searchDomainModel.value.maxMillageSearchParam
        ]
            .compactMap { $0 }
            .map { $0.queryString }
        
        var joinedParams: [String] = paramsArray.map { params in
            params.map { $0.queryString }.joined(separator: " or ")
        }
        
        joinedParams.append(contentsOf: rangeParams)
        
        let queryString = joinedParams.filter { !$0.isEmpty }.joined(separator: " and ")
        testSearchModelSubject.value = .init(params: paramsArray.flatMap({ $0 }), queryString: queryString)
    }
}

// MARK: - Constant
private enum Constant {
    static let nextPageSize: Int = 3
    static let countDefaultValue: Int = 0
}

struct SearchAdvertismentDomainModel {
    let basicBrand = BrandCellModel.basicBrands()
    var bodyType = BodyTypeCellModel.basicBodyTypes()
    var fuelType = FuelTypeModel.fuelTypes()
    var transmissionType = TransmissionTypeModel.transmissionTypes()
    var selectedBrand: [SelectedBrandModel] = []
    
    var maxYearSearchParam: SearchParam?
    var minYearSearchParam: SearchParam?
    
    var minPowerSearchParam: SearchParam?
    var maxPowerSearchParam: SearchParam?
    
    var minMillageSearchParam: SearchParam?
    var maxMillageSearchParam: SearchParam?
}


struct SearchTestModel {
    var params: [SearchParam] = []
    var queryString: String = ""
}
