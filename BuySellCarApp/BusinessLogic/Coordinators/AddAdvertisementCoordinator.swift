//
//  AddAdvertisementCoordinator.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 11.05.2023.
//

import UIKit
import Combine

final class AddAdvertisementCoordinator: Coordinator {
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
        addAdvertisementRoot()
    }
    
    deinit {
        print("Deinit of \(String(describing: self))")
    }
}

// MARK: - Private extension
private extension AddAdvertisementCoordinator {
    func addAdvertisementRoot() {
        let module = AddNewAdvertisementModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .showVehicleData:
                    vehicleDataModule()
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
    
    func vehicleDataModule() {
        let module = VehicleDataModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .showBrands:
                    brandsModule()
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }
    
    func brandsModule() {
        let module = BrandListModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                
            }
            .store(in: &cancellables)
        push(module.viewController)
    }
}

// MARK: - NavigationControler configuration
private extension AddAdvertisementCoordinator {
    func setupNavigationBar() {
        navigationController.navigationBar.tintColor = Colors.buttonDarkGray.color
    }
}
