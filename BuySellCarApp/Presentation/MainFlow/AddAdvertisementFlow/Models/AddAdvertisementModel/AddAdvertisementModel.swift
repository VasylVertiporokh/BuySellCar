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
    private let userDefaultsService: UserDefaultsServiceProtocol
    private let advertisementNetworkService: AdvertisementNetworkService
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
    init(userDefaultsService: UserDefaultsServiceProtocol, advertisementNetworkService: AdvertisementNetworkService) {
        self.userDefaultsService = userDefaultsService
        self.advertisementNetworkService = advertisementNetworkService
    }
}

// MARK: -
extension AddAdvertisementModelImpl: AddAdvertisementModel {
    func getOwnAds() {
        guard let ownerID = userDefaultsService.userID else {
            return
        }
        advertisementNetworkService.getOwnAds(ownerID: ownerID)
            .mapError { $0 as Error }
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.modelErrorSubject.send(error)
            } receiveValue: { [weak self] adsResponseModel in
                guard let self = self else { return }
                self.ownAdsSubject.send(adsResponseModel.map({AdvertisementDomainModel.init(advertisementResponseModel: $0)}))
            }
            .store(in: &cancellables)
    }
    
    func getBrands() {
        advertisementNetworkService.getBrands()
            .mapError { $0 as Error }
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.modelErrorSubject.send(error)
            } receiveValue: { [weak self] brandResponseModel in
                guard let self = self else {
                    return
                }
                self.brandsSubject.send(brandResponseModel.map { BrandDomainModel(brandResponseModel: $0) })
            }
            .store(in: &cancellables)
    }
    
    func getModelsById(_ brandId: String) {
        advertisementNetworkService.getModelsByBrandId(brandId)
            .mapError { $0 as Error }
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.modelErrorSubject.send(error)
            } receiveValue: { [weak self] modelsResponseModel in
                guard let self = self else {
                    return
                }
                self.modelsSubject.send(modelsResponseModel.map { ModelsDomainModel(modelResponseModel: $0) })
            }
            .store(in: &cancellables)
    }
    
    func deleteAdvertisementByID(_ id: String) {
        advertisementNetworkService.deleteAdvertisement(objectID: id)
            .mapError { $0 as Error }
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

