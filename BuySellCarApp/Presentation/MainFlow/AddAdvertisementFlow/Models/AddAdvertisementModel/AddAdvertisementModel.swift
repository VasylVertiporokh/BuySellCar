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
    var modelErrorPublisher: AnyPublisher<Error, Never> { get }
    
    func getOwnAds()
    func getBrands()
    func getModelsById(_ brandId: String)
    func deleteAdvertisementByID(_ id: String)
}

final class AddAdvertisementModelImpl {
    // MARK: - Private properties
    private let userService: UserService
    private let advertisementService: AdvertisementService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Subjects
    private let ownAdsSubject = CurrentValueSubject<[AdvertisementDomainModel], Never>([])
    private let brandsSubject = CurrentValueSubject<[BrandDomainModel], Never>([])
    private let modelsSubject = CurrentValueSubject<[ModelsDomainModel], Never>([])
    private let modelErrorSubject = PassthroughSubject<Error, Never>()
    
    // MARK: - Publishers
    lazy var ownAdsPublisher = ownAdsSubject.eraseToAnyPublisher()
    lazy var brandsPublisher = brandsSubject.eraseToAnyPublisher()
    lazy var modelsPublisher = modelsSubject.eraseToAnyPublisher()
    lazy var modelErrorPublisher = modelErrorSubject.eraseToAnyPublisher()
    
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
}
