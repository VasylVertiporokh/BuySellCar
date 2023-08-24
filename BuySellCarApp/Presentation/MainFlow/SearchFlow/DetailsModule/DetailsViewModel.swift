//
//  DetailsViewModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 01/08/2023.
//

import Combine
import Foundation
import UIKit

enum DetailsViewModelAction {
    case isFavorite(Bool)
    case loadingError
}

final class DetailsViewModel: BaseViewModel {
    // MARK: - Private properties
    private let userService: UserService
    private let adsDomainModel: AdvertisementDomainModel
    private var favoriteModel: FavoriteResponseModel?
    private var isFavorite: Bool = false
    
    // MARK: - Transition subject
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<DetailsTransition, Never>()
    
    // MARK: - AdvertisementDomainModel subject
    private(set) lazy var advertisementDomainModelPublisher = advertisementDomainModelSubject.eraseToAnyPublisher()
    private let advertisementDomainModelSubject = CurrentValueSubject<AdvertisementDomainModel?, Never>(nil)
    
    // MARK: - DetailsViewModelAction publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<DetailsViewModelAction, Never>()
    
    // MARK: - Init
    init(userService: UserService, adsDomainModel: AdvertisementDomainModel) {
        self.userService = userService
        self.adsDomainModel = adsDomainModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        advertisementDomainModelSubject.value = adsDomainModel
        getFavorite()
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
                    self?.actionSubject.send(.loadingError)
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
                    self?.actionSubject.send(.loadingError)
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
        actionSubject.send(.isFavorite(isFavorite))
    }
    
    func getFavorite() {
        userService.getFavoriteAds()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.actionSubject.send(.loadingError)
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
