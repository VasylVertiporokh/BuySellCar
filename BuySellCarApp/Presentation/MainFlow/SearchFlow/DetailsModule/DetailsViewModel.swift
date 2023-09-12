//
//  DetailsViewModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 01/08/2023.
//

import Combine
import Foundation
import UIKit

enum DetailsViewModelEvent {
    case isFavorite(Bool)
    case loadingError
    case offlineMode
    case onlineMode
}

final class DetailsViewModel: BaseViewModel {
    // MARK: - Private properties
    private let userService: UserService
    private let adsDomainModel: AdvertisementDomainModel
    private let reachabilityManager: ReachabilityManager = ReachabilityManagerImpl.shared
    private var favoriteModel: FavoriteResponseModel?
    private var isFavorite: Bool = false
    
    // MARK: - Transition subject
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<DetailsTransition, Never>()
    
    // MARK: - AdvertisementDomainModel subject
    private(set) lazy var advertisementDomainModelPublisher = advertisementDomainModelSubject.eraseToAnyPublisher()
    private let advertisementDomainModelSubject = CurrentValueSubject<AdvertisementDomainModel?, Never>(nil)
    
    // MARK: - DetailsViewModelAction publisher
    private(set) lazy var eventPublisher = eventSubject.eraseToAnyPublisher()
    private let eventSubject = PassthroughSubject<DetailsViewModelEvent, Never>()
    
    // MARK: - Init
    init(userService: UserService, adsDomainModel: AdvertisementDomainModel) {
        self.userService = userService
        self.adsDomainModel = adsDomainModel
        super.init()
    }
    
    // MARK: - Life cycle    
    override func onViewWillAppear() {
        super.onViewWillAppear()
        switch reachabilityManager.appMode {
        case .api:
            advertisementDomainModelSubject.value = adsDomainModel
            eventSubject.send(.onlineMode)
            getFavorite()
        case .database:
            advertisementDomainModelSubject.value = adsDomainModel
            eventSubject.send(.offlineMode)
        }
    }
}

// MARK: - Internal extension
extension DetailsViewModel {
    func showSelectedImage(imageRow: AdsImageRow) {
        guard let images = self.adsDomainModel.images?.carImages else {
            return
        }
        
        let items: [AdsImageRow] = images.map { .adsImageRow($0) }
        let model = CarouselImageView.ViewModel(
            sections: [.init(section: .adsImageSection, items: items)],
            selectedRow: imageRow
        )
        transitionSubject.send(.showImages(model))
    }
    
    func openSendEmail() {
        transitionSubject.send(.showSendEmail(adsDomainModel: adsDomainModel))
    }
    
    // TODO: - Need change this logic?
    func openWhatsApp() {
        let phoneNumber = adsDomainModel.ownerinfo.phoneNumber.replacingOccurrences(of: " ", with: "")
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        }
    }
    
    func makeCall() {
        let phone = adsDomainModel.ownerinfo.phoneNumber.replacingOccurrences(of: " ", with: "")
        let url = URL(string: "tel://\(phone)")
        guard let url = url else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func addToFavorite() {
        guard let currentAds = advertisementDomainModelSubject.value else {
            return
        }
        
        if isFavorite {
            userService.deleteFromFavorite(objectId: currentAds.objectID)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard case let .failure(error) = completion else {
                        return
                    }
                    self?.eventSubject.send(.loadingError)
                    self?.errorSubject.send(error)
                } receiveValue: { [weak self] favoriteAds in
                    guard let self = self else {
                        return
                    }
                    self.favoriteModel = favoriteAds
                    self.checkIsFavorite()
                }
                .store(in: &cancellables)
        } else {
            userService.addToFavorite(objectId: currentAds.objectID)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard case let .failure(error) = completion else {
                        return
                    }
                    self?.eventSubject.send(.loadingError)
                    self?.errorSubject.send(error)
                } receiveValue: { [weak self] favoriteAds in
                    guard let self = self else {
                        return
                    }
                    self.favoriteModel = favoriteAds
                    self.checkIsFavorite()
                }
                .store(in: &cancellables)
        }
    }
    
    func finishFlow() {
        transitionSubject.send(.finishFlow)
    }
}

// MARK: - Private extension
private extension DetailsViewModel {
    func checkIsFavorite() {
        guard let favoriteModel = favoriteModel else {
            return
        }
        isFavorite = favoriteModel.favorite.contains { $0.objectID == advertisementDomainModelSubject.value?.objectID }
        eventSubject.send(.isFavorite(isFavorite))
    }
    
    func getFavorite() {
        userService.getFavoriteAds()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.eventSubject.send(.loadingError)
                self?.errorSubject.send(error)
            } receiveValue: { [weak self] ads in
                guard let self = self else {
                    return
                }
                self.favoriteModel = ads
                self.checkIsFavorite()
            }
            .store(in: &cancellables)
    }
}
