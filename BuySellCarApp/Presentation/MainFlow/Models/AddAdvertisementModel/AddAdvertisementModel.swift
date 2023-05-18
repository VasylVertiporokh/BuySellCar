//
//  AddAdvertisementModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 12.05.2023.
//

import Foundation
import Combine

protocol AddAdvertisementModel {
    var ownAdsPublisher: AnyPublisher<[AdvertisementDomainModel], Never> { get }
    var brandsPublisher: AnyPublisher<[BrandDomainModel], Never> { get }
    var modelsPublisher: AnyPublisher<[ModelsDomainModel], Never> { get }
    var isAllFieldsValidPublisher: AnyPublisher<Bool, Never> { get }
    var modelErrorPublisher: AnyPublisher<Error, Never> { get }
    var carColorArray: [CarColor] { get }
    var fuelTypesArray: [FuelType] { get }
    var addAdsDomainModelPublisher: AnyPublisher<AddAdvertisementDomainModel, Never> { get }
    
    func getOwnAds()
    func getBrands()
    func getModelsById(_ brandId: String)
    func deleteAdvertisementByID(_ id: String)
    func setBrand(model: BrandCellConfigurationModel)
    func setModel(model: ModelCellConfigurationModel)
    func setRegistrationData(date: Date)
    func setFuelType(type: FuelType)
    func setCarColor(color: CarColor)
    func resetAdCreation()
}

final class AddAdvertisementModelImpl {
    // MARK: - Internal properties
    private(set) var fuelTypesArray: [FuelType] = FuelType.fuelTypes
    private(set) var carColorArray: [CarColor] = CarColor.colorsList
    
    // MARK: - Private properties
    private let userService: UserService
    private let advertisementService: AdvertisementService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Subjects
    private let ownAdsSubject = CurrentValueSubject<[AdvertisementDomainModel], Never>([])
    private let brandsSubject = CurrentValueSubject<[BrandDomainModel], Never>([])
    private let modelsSubject = CurrentValueSubject<[ModelsDomainModel], Never>([])
    private let isAllFieldsValidSubject = CurrentValueSubject<Bool, Never>(false)
    private let modelErrorSubject = PassthroughSubject<Error, Never>()
    private let addAdsDomainModelSubject = CurrentValueSubject<AddAdvertisementDomainModel, Never>(.init())
    
    // MARK: - Publishers
    lazy var ownAdsPublisher = ownAdsSubject.eraseToAnyPublisher()
    lazy var brandsPublisher = brandsSubject.eraseToAnyPublisher()
    lazy var modelsPublisher = modelsSubject.eraseToAnyPublisher()
    lazy var modelErrorPublisher = modelErrorSubject.eraseToAnyPublisher()
    lazy var addAdsDomainModelPublisher = addAdsDomainModelSubject.eraseToAnyPublisher()
    lazy var isAllFieldsValidPublisher = isAllFieldsValidSubject.eraseToAnyPublisher()
    
    // MARK: - Init
    init(userService: UserService, advertisementService: AdvertisementService) {
        self.userService = userService
        self.advertisementService = advertisementService      
    }
}

// MARK: -
extension AddAdvertisementModelImpl: AddAdvertisementModel {
    func getOwnAds() {
        guard let ownerID = userService.user?.ownerID else {
            return
        }
        
        advertisementService.getOwnAds(byID: ownerID)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.modelErrorSubject.send(error)
            } receiveValue: { [weak self] adsDomainModel in
                guard let self = self else { return }
                self.ownAdsSubject.send(adsDomainModel)
            }
            .store(in: &cancellables)
    }
    
    func getBrands() {
        advertisementService.getBrands()
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.modelErrorSubject.send(error)
            } receiveValue: { [weak self] brandsDomainModel in
                guard let self = self else {
                    return
                }
                self.brandsSubject.send(brandsDomainModel.sorted { $0.name < $1.name })
            }
            .store(in: &cancellables)
    }
    
    func getModelsById(_ brandId: String) {
        advertisementService.getModelsByBrandId(brandId)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.modelErrorSubject.send(error)
            } receiveValue: { [weak self] modelsDomainModel in
                guard let self = self else {
                    return
                }
                self.modelsSubject.send(modelsDomainModel)
            }
            .store(in: &cancellables)
    }
    
    func deleteAdvertisementByID(_ id: String) {
        advertisementService.deleteAdvertisementByID(id)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.modelErrorSubject.send(error)
            } receiveValue: { [weak self] in
                guard let self = self else {
                    return
                }
                self.ownAdsSubject.value.removeAll { $0.objectID == id }
            }
            .store(in: &cancellables)
    }
    
    func setBrand(model: BrandCellConfigurationModel) {
        addAdsDomainModelSubject.value = .init()
        addAdsDomainModelSubject.value.make = model.brandName
        addAdsDomainModelSubject.value.model = ""
        isAllFieldsValidSubject.send(false)
    }
    
    func setModel(model: ModelCellConfigurationModel) {
        addAdsDomainModelSubject.value.model = model.modelName
        addAdsDomainModelSubject.value.firstRegistration = .init()
        addAdsDomainModelSubject.value.fuelType = .petrol
    }
    
    func setRegistrationData(date: Date) {
        addAdsDomainModelSubject.value.firstRegistration?.dateString = date.convertToString(format: .monthYear)
        addAdsDomainModelSubject.value.firstRegistration?.dateInt = date.convertToIntYear
    }
    
    func setFuelType(type: FuelType) {
        addAdsDomainModelSubject.value.fuelType = type
        addAdsDomainModelSubject.value.bodyColor = .white
        isAllFieldsValidSubject.send(true)
    }
    
    func setCarColor(color: CarColor) {
        addAdsDomainModelSubject.value.bodyColor = color
    }
    
    func resetAdCreation() {
        addAdsDomainModelSubject.value = .init()
        isAllFieldsValidSubject.send(false)
    }
}

// TODO: - Replace with an existing domain model (after the demo)
// MARK: - AddAdvertisementDomainModel
struct AddAdvertisementDomainModel {
    var make: String?
    var model: String?
    var firstRegistration: FirstRegistrationDataModel?
    var fuelType: FuelType?
    var bodyColor: CarColor?
}

struct FirstRegistrationDataModel {
    var dateString: String = Date().convertToString(format: .monthYear)
    var dateInt: Int = Date().convertToIntYear
}
