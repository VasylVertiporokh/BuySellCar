//
//  EditUserProfileModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 20.03.2023.
//

import UIKit
import Combine

enum EditUserProfileTransition: Transition {
    case logout
}

final class EditUserProfileModuleBuilder {
    class func build(container: AppContainer) -> Module<EditUserProfileTransition, UIViewController> {
        let viewModel = EditUserProfileViewModel(userService: container.userService)
        let viewController = EditUserProfileViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
