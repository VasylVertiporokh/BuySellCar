//
//  SettingsModuleBuilder.swift
//  MVVMSkeleton
//
//

import UIKit
import Combine

enum SettingsTransition: Transition {
    case showEditProfile
}

final class SettingsModuleBuilder {
    class func build(container: AppContainer) -> Module<SettingsTransition, UIViewController> {
        let viewModel = SettingsViewModel(userService: container.userService)
        let viewController = SettingsViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
