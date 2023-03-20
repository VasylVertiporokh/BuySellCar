//
//  RestorePasswordModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 27.02.2023.
//

import UIKit
import Combine

enum RestorePasswordTransition: Transition {
    case dismiss
}

final class RestorePasswordModuleBuilder {
    class func build(container: AppContainer) -> Module<RestorePasswordTransition, UIViewController> {
        let viewModel = RestorePasswordViewModel(networkService: container.authNetworkService)
        let viewController = RestorePasswordViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
