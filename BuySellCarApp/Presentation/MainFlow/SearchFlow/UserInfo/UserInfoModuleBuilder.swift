//
//  UserInfoModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 01.03.2023.
//

import UIKit
import Combine

enum UserInfoTransition: Transition {
    
}

final class UserInfoModuleBuilder {
    class func build(container: AppContainer) -> Module<UserInfoTransition, UIViewController> {
        let viewModel = UserInfoViewModel(userService: container.userService, tempService: container.tempNetService)
        let viewController = UserInfoViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
