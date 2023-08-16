//
//  DetailsViewModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 01/08/2023.
//

import Combine
import Foundation
import UIKit

final class DetailsViewModel: BaseViewModel {
    // MARK: - Private properties
    private let adsDomainModel: AdvertisementDomainModel
    
    // MARK: - Transition subject
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<DetailsTransition, Never>()
    
    // MARK: - AdvertisementDomainModel subject
    private(set) lazy var advertisementDomainModelPublisher = advertisementDomainModelSubject.eraseToAnyPublisher()
    private let advertisementDomainModelSubject = CurrentValueSubject<AdvertisementDomainModel?, Never>(nil)
    
    // MARK: - Init
    init(adsDomainModel: AdvertisementDomainModel) {
        self.adsDomainModel = adsDomainModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        advertisementDomainModelSubject.value = adsDomainModel
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
        guard let ownerId = adsDomainModel.ownerID else {
            return
        }
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
}
