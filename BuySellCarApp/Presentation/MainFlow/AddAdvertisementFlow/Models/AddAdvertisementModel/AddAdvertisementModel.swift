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
    var successfulPublicationPublisher: AnyPublisher<Void, Never> { get }
    var carColorArray: [CarColor] { get }
    var fuelTypesArray: [FuelType] { get }
    var addAdsDomainModelPublisher: AnyPublisher<AddAdvertisementDomainModel, Never> { get }
    
    func getOwnAds()
    func getBrands()
    func setAddAdvertisemenOwnerId()
    func getModelsById(_ brandId: String)
    func deleteAdvertisementByID(_ id: String)
    func setBrand(model: BrandCellConfigurationModel)
    func setModel(model: ModelCellConfigurationModel)
    func setRegistrationData(date: Date)
    func setFuelType(type: FuelType)
    func setCarColor(color: CarColor)
    func userLocationRequest()
    func setAdvertisementPhoto(_ photoData: Data?, collageID: String)
    func publishAdvertisement(technicalInfoModel: TechnicalInfoModel)
    func deleteImageByID(_ id: String)
    func resetAdCreation()
}

final class AddAdvertisementModelImpl {
    // MARK: - Internal properties
    private(set) var fuelTypesArray: [FuelType] = FuelType.allCases
    private(set) var carColorArray: [CarColor] = CarColor.allCases
    
    // MARK: - Private properties
    private let userService: UserService
    private let advertisementService: AdvertisementService
    private let userLocationService: UserLocationService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Subjects
    private let ownAdsSubject = CurrentValueSubject<[AdvertisementDomainModel], Never>([])
    private let brandsSubject = CurrentValueSubject<[BrandDomainModel], Never>([])
    private let modelsSubject = CurrentValueSubject<[ModelsDomainModel], Never>([])
    private let isAllFieldsValidSubject = CurrentValueSubject<Bool, Never>(false)
    private let successfulPublicationSubject = PassthroughSubject<Void, Never>()
    private let modelErrorSubject = PassthroughSubject<Error, Never>()
    private let addAdsDomainModelSubject = CurrentValueSubject<AddAdvertisementDomainModel, Never>(.init())
    
    // MARK: - Publishers
    lazy var ownAdsPublisher = ownAdsSubject.eraseToAnyPublisher()
    lazy var brandsPublisher = brandsSubject.eraseToAnyPublisher()
    lazy var modelsPublisher = modelsSubject.eraseToAnyPublisher()
    lazy var modelErrorPublisher = modelErrorSubject.eraseToAnyPublisher()
    lazy var successfulPublicationPublisher = successfulPublicationSubject.eraseToAnyPublisher()
    lazy var addAdsDomainModelPublisher = addAdsDomainModelSubject.eraseToAnyPublisher()
    lazy var isAllFieldsValidPublisher = isAllFieldsValidSubject.eraseToAnyPublisher()
    
    // MARK: - For testing
    private let dispatchGroup = DispatchGroup()
    
    // MARK: - Init
    init(userService: UserService, advertisementService: AdvertisementService, userLocationService: UserLocationService) {
        self.userService = userService
        self.advertisementService = advertisementService
        self.userLocationService = userLocationService
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
    
    func setAdvertisementPhoto(_ photo: Data?, collageID: String) {
        guard let index = addAdsDomainModelSubject.value.adsPhotoModel.firstIndex(where: { $0.id == collageID }) else {
            return
        }
        addAdsDomainModelSubject.value.adsPhotoModel[index].selectedImage = photo
    }
    
    func publishAdvertisement(technicalInfoModel: TechnicalInfoModel) {
        guard let ownedID = userService.user?.ownerID else {
            return
        }
        
        let photos = addAdsDomainModelSubject.value.adsPhotoModel.compactMap { $0.selectedImage }
        let multipartItems: [MultipartItem] = photos.map { .init(data: $0, fileName: "\(UUID().uuidString).png") }
        
        addAdsDomainModelSubject.value.mainTechnicalInfo = technicalInfoModel
        guard !multipartItems.isEmpty else {
            advertisementService.publishAdvertisement(model: addAdsDomainModelSubject.value)
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
                self.advertisementService.publishAdvertisement(model: self.addAdsDomainModelSubject.value)
                    .sink { [unowned self] completion in
                        guard case let .failure(error) = completion else {
                            return
                        }
                        self.modelErrorSubject.send(error)
                    } receiveValue: { [unowned self] in successfulPublicationSubject.send($0) }
                    .store(in: &self.cancellables)
        }
    }
    
    func deleteImageByID(_ id: String) {
        guard let index = addAdsDomainModelSubject.value.adsPhotoModel.firstIndex(where: { $0.id == id }) else {
            return
        }
        addAdsDomainModelSubject.value.adsPhotoModel[index].selectedImage = nil
    }
    
    func resetAdCreation() {
        addAdsDomainModelSubject.value = .init()
        isAllFieldsValidSubject.send(false)
    }
}
