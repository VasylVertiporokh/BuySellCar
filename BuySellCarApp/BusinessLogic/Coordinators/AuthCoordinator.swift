//
//  AuthCoordinator.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import UIKit
import Combine

final class AuthCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let container: AppContainer
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        authSelect()
    }

    private func authSelect() {
        let module = AuthSelectModuleBuilder.build()
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .skip:
                    didFinishSubject.send()
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }
}
