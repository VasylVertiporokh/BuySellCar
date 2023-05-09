//
//  HomeCoordinator.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import UIKit
import Combine

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private let container: AppContainer
    private var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
        setupNavigationBar()
    }

    func start() {
        searchRoot()
    }
    
    deinit {
        print("Deinit of \(String(describing: self))")
    }
}

// MARK: - Private extension
private extension HomeCoordinator {
    func searchRoot() {
        let module = AdvertisementRecomendationModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .showResult(let model):
                    showSearchResult(model: model)
                case .startSearch(let model):
                    startSearch(model: model)
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
    
    func showSearchResult(model: AdvertisementModel) {
        let module = SearchResultModuleBuilder.build(container: container, model: model)
        module.transitionPublisher
            .sink { [unowned self] transition in
                
            }
            .store(in: &cancellables)
        module.viewController.hidesBottomBarWhenPushed = true
        push(module.viewController)
    }
    
    func startSearch(model: AdvertisementModel) {
        let module = SearchAdvertisementModuleBuilder.build(container: container, model: model)
        module.transitionPublisher
            .sink { [unowned self] transition in
                
            }
            .store(in: &cancellables)
        push(module.viewController)
    }
}

// MARK: - NavigationControler configuration
private extension HomeCoordinator {
    func setupNavigationBar() {
        navigationController.navigationBar.tintColor = Colors.buttonDarkGray.color
    }
}
