//
//  SignInModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import UIKit
import Combine

enum SignInTransition: Transition {
    case showMainFlow
    case restorePassword
    case createAccount
}

final class SignInModuleBuilder {
    class func build(container: AppContainer) -> Module<SignInTransition, UIViewController> {
        let viewModel = SignInViewModel(
            networkService: container.aurhNetworkService,
            userService: container.userService
        )
        let viewController = SignInViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
