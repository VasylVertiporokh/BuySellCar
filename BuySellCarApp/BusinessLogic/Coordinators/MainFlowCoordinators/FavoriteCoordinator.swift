//
//  FavouriteCoordinator.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 21/08/2023.
//

import UIKit
import Combine

final class FavoriteCoordinator: Coordinator {
    // MARK: - Internal properties
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    // MARK: - Private properties
    private let container: AppContainer
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - DidFinish publisher
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    // MARK: - Initial module
    func start() {
        favoriteRoot()
    }
}

// MARK: - Private extenison
private extension FavoriteCoordinator {
    func favoriteRoot() {
        let module = FavoriteModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .showDetails(let ads):
                    showDetails(selectedAds: ads)
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
    
    func showDetails(selectedAds: AdvertisementDomainModel) {
        let coordinator = DetailsCoordinator(
            navigationController: navigationController,
            container: container,
            selectedAds: selectedAds
        )
        coordinator.didFinishPublisher
            .sink { [unowned self] in
                removeChild(coordinator: coordinator)
            }
            .store(in: &cancellables)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
