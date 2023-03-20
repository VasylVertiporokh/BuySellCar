//
//  CreateAccountModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.02.2023.
//

import UIKit
import Combine

enum CreateAccountTransition: Transition {
    case showMainFlow
    case popToRoot
}

final class CreateAccountModuleBuilder {
    class func build(container: AppContainer) -> Module<CreateAccountTransition, UIViewController> {
        let viewModel = CreateAccountViewModel(authService: container.authNetworkService)
        let viewController = CreateAccountViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
