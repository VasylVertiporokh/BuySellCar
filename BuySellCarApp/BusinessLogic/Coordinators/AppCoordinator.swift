//
//  AppCoordinator.swift
//  MVVMSkeleton
//
//

import UIKit
import Combine

enum UserAuthorizationStatus: Int, CaseIterable {
    case authorized
    case nonAuthorized
}

final class AppCoordinator: Coordinator {
    
    // MARK: - Internal properties
    var window: UIWindow
    var navigationController: UINavigationController
    let container: AppContainer
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Private properties
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(window: UIWindow, container: AppContainer, navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        fakeSplash()
    }
}

// MARK: - Private extension
private extension AppCoordinator {
    func fakeSplash() {
        let module = FakeSplashModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .didFinish(let status):
                    switch status {
                    case .authorized:
                        mainFlow()
                    case .nonAuthorized:
                        authFlow()
                    }
                }
            }
            .store(in: &cancellables)
        
        setRoot(module.viewController)
    }
    
    func authFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController,
                                              container: container)
        childCoordinators.append(authCoordinator)
        authCoordinator.didFinishPublisher
            .sink { [unowned self] in
                mainFlow()
                removeChild(coordinator: authCoordinator)
            }
            .store(in: &cancellables)
        authCoordinator.start()
    }
    
    func mainFlow() {
        let mainCoordinator = MainTabBarCoordinator(navigationController: navigationController,
                                                    container: container)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.didFinishPublisher
            .sink { [unowned self] in
                authFlow()
                removeChild(coordinator: mainCoordinator)
            }
            .store(in: &cancellables)
        mainCoordinator.start()
    }
}
