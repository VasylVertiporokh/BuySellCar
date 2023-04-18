//
//  FakeSplashModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.04.2023.
//

import UIKit
import Combine

enum FakeSplashTransition: Transition {
    case didFinish(status: UserAuthorizationStatus)
}

final class FakeSplashModuleBuilder {
    class func build(container: AppContainer) -> Module<FakeSplashTransition, UIViewController> {
        let viewModel = FakeSplashViewModel(
            authService: container.authNetworkService,
            tokenStorage: container.tokenStorage,
            userService: container.userService
        )
        let viewController = FakeSplashViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
