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
        showLogin()
    }
    
    deinit {
        print("Deinit of \(String(describing: self))")
    }
    
    private func showLogin() {
        let module = SignInModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .showMainFlow:
                    didFinishSubject.send()
                    didFinishSubject.send(completion: .finished)
                case .restorePassword:
                    showRestorePassword()
                case .createAccount:
                    createAccount()
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }
    
    func createAccount() {
        let module = CreateAccountModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .popToRoot:
                    dismiss()
                case .showMainFlow:
                    didFinishSubject.send()
                    didFinishSubject.send(completion: .finished)
                }
            }
            .store(in: &cancellables)
        presentWithStyle(module.viewController, style: .fullScreen)
    }
    
    func showRestorePassword() {
        let module = RestorePasswordModuleBuilder.build(container: container)
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
