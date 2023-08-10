//
//  DetailsViewModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 01/08/2023.
//

import Combine
import Foundation

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
}
