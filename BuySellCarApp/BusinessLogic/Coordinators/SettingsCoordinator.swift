//
//  SettingsCoordinator.swift
//  MVVMSkeleton
//
//

import UIKit
import Combine

final class SettingsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private let container: AppContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        settingsRoot()
    }
    
    deinit {
        print("Deinit of \(String(describing: self))")
    }
}

// MARK: - Private extension
private extension SettingsCoordinator {
    func settingsRoot() {
        let module = SettingsModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .showEditProfile:
                    showEditProfile()
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
    
    func showEditProfile() {
        let module = EditUserProfileModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .logout:
                    didFinishSubject.send()
                }
            }
            .store(in: &cancellables)
        module.viewController.hidesBottomBarWhenPushed = true
        push(module.viewController)
    }
}
