//
//  MainTabBarCoordinator.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import UIKit
import Combine

final class MainTabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let container: AppContainer
    
    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    deinit {
        print("Deinit of \(String(describing: self))")
    }
    
    func start() {
        setupHomeCoordinator()
        setupAddAdvertisementCoordinator()
        setupSettingsCoordinator()
        
        let controllers = childCoordinators.compactMap { $0.navigationController }
        let module = MainTabBarModuleBuilder.build(viewControllers: controllers)
        setRoot(module.viewController)
    }
}

// MARK: - Private extension
private extension MainTabBarCoordinator {
    func setupHomeCoordinator() {
        let navController = UINavigationController()
        navController.tabBarItem = .init(title: Localization.search,
                                         image: Assets.searchIcon.image,
                                         selectedImage: nil)
        let coordinator = HomeCoordinator(navigationController: navController, container: container)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func setupAddAdvertisementCoordinator() {
        let navController = UINavigationController()
        navController.tabBarItem = .init(title: Localization.selling,
                                         image: Assets.addAdv.image,
                                         selectedImage: nil)
        let coordinator = AddAdvertisementCoordinator(navigationController: navController, container: container)
        childCoordinators.append(coordinator)
        coordinator.didFinishPublisher
            .sink { [unowned self] in
                childCoordinators.forEach { removeChild(coordinator: $0) }
                didFinishSubject.send()
                didFinishSubject.send(completion: .finished)
            }
            .store(in: &cancellables)
        coordinator.start()
    }
    
    func setupSettingsCoordinator() {
        let navController = UINavigationController()
        navController.tabBarItem = .init(title: Localization.settings,
                                         image: UIImage(systemName: "gear"),
                                         selectedImage: nil)
        let coordinator = SettingsCoordinator(navigationController: navController, container: container)
        childCoordinators.append(coordinator)
        coordinator.didFinishPublisher
            .sink { [unowned self] in
                childCoordinators.forEach { removeChild(coordinator: $0) }
                didFinishSubject.send()
                didFinishSubject.send(completion: .finished)
            }
            .store(in: &cancellables)
        coordinator.start()
    }
}
