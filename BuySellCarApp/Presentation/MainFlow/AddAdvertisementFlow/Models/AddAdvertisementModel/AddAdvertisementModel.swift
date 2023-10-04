//
//  AddAdvertisementModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 12.05.2023.
//

import Foundation
import Combine

enum BaseTechnicalInfoParameters {
    case millage(Int)
    case price(Int)
    case power(Int)
}

protocol AddAdvertisementModel {
    var ownAdsPublisher: AnyPublisher<[AdvertisementDomainModel], Never> { get }
    var brandsPublisher: AnyPublisher<[BrandDomainModel], Never> { get }
    var modelsPublisher: AnyPublisher<[ModelsDomainModel], Never> { get }
    var isAllFieldsValidPublisher: AnyPublisher<Bool, Never> { get }
    var modelErrorPublisher: AnyPublisher<Error, Never> { get }
    var successfulPublicationPublisher: AnyPublisher<Void, Never> { get }
    var offlineModePublisher: AnyPublisher<AppDataMode, Never> { get }
    var carColorArray: [CarColor] { get }
    var fuelTypesArray: [FuelType] { get }
    var addAdsDomainModelPublisher: AnyPublisher<AddAdvertisementDomainModel, Never> { get }
    
    func getOwnAds()
    func getBrands()
    func setAddAdvertisemenOwnerId()
    func getModelsById(_ brandId: String)
    func getModelsForCurrentBrand()
    func deleteAdvertisementByID(_ id: String)
    func setBrand(model: BrandCellConfigurationModel)
    func setModel(model: ModelCellConfigurationModel)
    func setRegistrationData(date: Date)
    func setFuelType(type: FuelType)
    func setCarColor(color: CarColor)
    func userLocationRequest()
    func setAdvertisementPhoto(_ photoData: Data?, racurs: AdsPhotoModel.Racurs)
    func publishAdvertisement()
    func deleteImageByRacurs(_ racurs: AdsPhotoModel.Racurs)
    func resetAdCreation()
    func configureEditModel(by id: String)
    func setBaseParameters(baseParams: BaseTechnicalInfoParameters)
    func setNumberOfSeats(_ numberOfSeats: Int)
    func setNumberOfDoors(_ numberOfDoors: Int)
    func setBodyType(_ bodyType: String)
    func setCondition(_ condition: String)
}

final class AddAdvertisementModelImpl {
    // MARK: - Internal properties
    private(set) var fuelTypesArray: [FuelType] = FuelType.allCases
    private(set) var carColorArray: [CarColor] = CarColor.allCases
    
    // MARK: - Private properties
    private let userService: UserService
    private let advertisementService: AdvertisementService
    private let userLocationService: UserLocationService
    private let ownAdsStorageService: AdsStorageService
    private let reachabilityManager: ReachabilityManager = ReachabilityManagerImpl.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Subjects
    private let ownAdsSubject = CurrentValueSubject<[AdvertisementDomainModel], Never>([])
    private let brandsSubject = CurrentValueSubject<[BrandDomainModel], Never>([])
    private let modelsSubject = CurrentValueSubject<[ModelsDomainModel], Never>([])
    private let isAllFieldsValidSubject = CurrentValueSubject<Bool, Never>(false)
    private let successfulPublicationSubject = PassthroughSubject<Void, Never>()
    private let offlineModeSubject = PassthroughSubject<AppDataMode, Never>()
    private let modelErrorSubject = PassthroughSubject<Error, Never>()
    private let addAdsDomainModelSubject = CurrentValueSubject<AddAdvertisementDomainModel, Never>(.init())
    
    // MARK: - Publishers
    lazy var ownAdsPublisher = ownAdsSubject.eraseToAnyPublisher()
    lazy var brandsPublisher = brandsSubject.eraseToAnyPublisher()
    lazy var modelsPublisher = modelsSubject.eraseToAnyPublisher()
    lazy var modelErrorPublisher = modelErrorSubject.eraseToAnyPublisher()
    lazy var successfulPublicationPublisher = successfulPublicationSubject.eraseToAnyPublisher()
    lazy var offlineModePublisher = offlineModeSubject.eraseToAnyPublisher()
    lazy var addAdsDomainModelPublisher = addAdsDomainModelSubject.eraseToAnyPublisher()
    lazy var isAllFieldsValidPublisher = isAllFieldsValidSubject.eraseToAnyPublisher()
    
    // MARK: - Temp solution
    private let dispatchGroup = DispatchGroup()
    
    // MARK: - Init
    init(
        userService: UserService,
        advertisementService: AdvertisementService,
        userLocationService: UserLocationService,
        ownAdsStorageService: AdsStorageService
    ) {
        self.userService = userService
        self.advertisementService = advertisementService
        self.userLocationService = userLocationService
        self.ownAdsStorageService = ownAdsStorageService
    }
}

// MARK: - AddAdvertisementModel
extension AddAdvertisementModelImpl: AddAdvertisementModel {
    func setBaseParameters(baseParams: BaseTechnicalInfoParameters) {
        switch baseParams {
        case .millage(let value):
            addAdsDomainModelSubject.value.mainTechnicalInfo.millage = value
        case .price(let value):
            addAdsDomainModelSubject.value.mainTechnicalInfo.price = value
        case .power(let value):
            addAdsDomainModelSubject.value.mainTechnicalInfo.power = value
        }
    }
    
    func getOwnAds() {
        guard let ownerID = userService.user?.ownerID else {
            return
        }
        ownAdsStorageService.fetchAdsByType(.ownAds)
        
        switch reachabilityManager.appMode {
        case .api:
            ownAdsSubject.send(ownAdsStorageService.ownAds)
            advertisementService.getOwnAds(byID: ownerID)
                .sink { [weak self] completion in
                    guard case let .failure(error) = completion else {
                        return
                    }
                    self?.modelErrorSubject.send(error)
                } receiveValue: { [weak self] adsDomainModel in
                    guard let self = self else { return }
                    self.ownAdsSubject.send(adsDomainModel)
                    self.ownAdsStorageService.synchronizeAdsByType(.ownAds, adsDomainModel: adsDomainModel)
                }
                .store(in: &cancellables)
        case .database:
            ownAdsSubject.send(ownAdsStorageService.ownAds)
            offlineModeSubject.send(.database)
        }
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
    
    func setAddAdvertisemenOwnerId() {
        guard let user = userService.user else {
            return
        }
        addAdsDomainModelSubject.value.ownerId = user.ownerID
        addAdsDomainModelSubject.value.sellerName = user.userName
        addAdsDomainModelSubject.value.contactsInfo = .init(email: user.email, phoneNumber: user.phoneNumber)
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
    
    func getModelsForCurrentBrand() {
        guard let currnetBrandName = addAdsDomainModelSubject.value.make,
              let currnetBrand = brandsSubject.value.first(where: { $0.name == currnetBrandName }) else {
            return
        }
        advertisementService.getModelsByBrandId(currnetBrand.id)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.modelErrorSubject.send(error)
            } receiveValue: { [weak self] models in
                guard let self = self else {
                    return
                }
                modelsSubject.value = models
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
        addAdsDomainModelSubject.value.fuelType = .other
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
    
    func userLocationRequest() {
        userLocationService.requestLocation()
        userLocationService.userAddressPublisher
            .sink { [unowned self] address in
                addAdsDomainModelSubject.value.location = address
            }
            .store(in: &cancellables)
    }
    
    func setAdvertisementPhoto(_ photo: Data?, racurs: AdsPhotoModel.Racurs) {
        guard let index = addAdsDomainModelSubject.value.adsPhotoModel.firstIndex(where: { $0.photoRacurs == racurs }) else {
            return
        }
        addAdsDomainModelSubject.value.adsPhotoModel[index].selectedImage = photo
    }
    
    func publishAdvertisement() {
        guard let ownedID = userService.user?.ownerID else {
            return
        }
        
        let photos = addAdsDomainModelSubject.value.adsPhotoModel.compactMap { $0.selectedImage }
        let multipartItems: [MultipartItem] = photos.map { .init(data: $0, fileName: "\(UUID().uuidString).png") }
        
        guard !multipartItems.isEmpty else {
            advertisementService.publishAdvertisement(model: addAdsDomainModelSubject.value, ownerId: ownedID)
                .sink { [unowned self] completion in
                    guard case let .failure(error) = completion else {
                        return
                    }
                    modelErrorSubject.send(error)
                } receiveValue: { [unowned self] in successfulPublicationSubject.send($0) }
                .store(in: &self.cancellables)
            return
        }
        var advertisementImages = AdvertisementImages(carImages: [])
        
        multipartItems.forEach { item in
            dispatchGroup.enter()
            self.advertisementService.uploadAdvertisementImage(item: item, userID: ownedID)
                .sink { [unowned self] completion in
                    guard case let .failure(error) = completion else {
                        return
                    }
                    modelErrorSubject.send(error)
                } receiveValue: { [unowned self] imageURL in
                    advertisementImages.carImages?.append(imageURL.fileURL)
                    self.dispatchGroup.leave()
                }
                .store(in: &self.cancellables)
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global(qos: .default)) {
            self.addAdsDomainModelSubject.value.images = advertisementImages
            self.advertisementService.publishAdvertisement(model: self.addAdsDomainModelSubject.value, ownerId: ownedID)
                .sink { [unowned self] completion in
                    guard case let .failure(error) = completion else {
                        return
                    }
                    self.modelErrorSubject.send(error)
                } receiveValue: { [unowned self] in successfulPublicationSubject.send($0) }
                .store(in: &self.cancellables)
        }
    }
    
    func deleteImageByRacurs(_ racurs: AdsPhotoModel.Racurs) {
        guard let index = addAdsDomainModelSubject.value.adsPhotoModel.firstIndex(where: { $0.photoRacurs == racurs }) else {
            return
        }
        addAdsDomainModelSubject.value.adsPhotoModel[index].selectedImage = nil
    }
    
    func resetAdCreation() {
        addAdsDomainModelSubject.value = .init()
        isAllFieldsValidSubject.send(false)
    }
    
    func configureEditModel(by id: String) {
        guard let modelForEdit = ownAdsSubject.value.first(where: { $0.objectID == id }) else {
            return
        }
        addAdsDomainModelSubject.value = .init(model: modelForEdit)
    }
    
    func setNumberOfSeats(_ numberOfSeats: Int) {
        addAdsDomainModelSubject.value.numberOfSeats = numberOfSeats
    }
    
    func setNumberOfDoors(_ numberOfDoors: Int) {
        addAdsDomainModelSubject.value.doorCount = numberOfDoors
    }
    
    func setBodyType(_ bodyType: String) {
        addAdsDomainModelSubject.value.bodyType = .init(rawString: bodyType)
    }
    
    func setCondition(_ condition: String) {
        addAdsDomainModelSubject.value.condition = .init(rawString: condition)
    }
}
