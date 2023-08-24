//
//  DetailsCoordinator.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 23/08/2023.
//

import UIKit
import Combine

final class DetailsCoordinator: Coordinator {
    // MARK: - Internal properties
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Private properties
    private let container: AppContainer
    private var cancellables = Set<AnyCancellable>()
    private let selectedAds: AdvertisementDomainModel
    
    // MARK: - DidFinish publisher
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(navigationController: UINavigationController, container: AppContainer, selectedAds: AdvertisementDomainModel) {
        self.navigationController = navigationController
        self.container = container
        self.selectedAds = selectedAds
    }
    
    // MARK: - Initial module
    func start() {
        showDetails()
    }
    
    // MARK: - Deinit
    deinit {
        print("Deinit of \(String(describing: self))")
    }
}

// MARK: - Private extenison
private extension DetailsCoordinator {
    func showDetails() {
        let module = DetailsModuleBuilder.build(container: container, adsModel: selectedAds)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .showImages(let advertisementImages):
                    showImageCarousel(model: advertisementImages)
                case .showSendEmail(let adsModel):
                    showSendEmail(adsDomainModel: adsModel)
                case .finishFlow:
                    didFinishSubject.send()
                    didFinishSubject.send(completion: .finished)
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }
    
    func showImageCarousel(model: CarouselImageView.ViewModel) {
        let module = CarouselImageModuleBuilder.build(container: container, model: model)
        presentWithStyle(module.viewController, animated: true, style: .overFullScreen)
    }
    
    func showSendEmail(adsDomainModel: AdvertisementDomainModel) {
        let module = SendEmailModuleBuilder.build(container: container, adsDomainModel: adsDomainModel)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .dismiss:
                    dismiss()
                }
            }
            .store(in: &cancellables)
        present(module.viewController)
    }
}
