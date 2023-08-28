//
//  MainTabBarModuleBuilder.swift
//  MVVMSkeleton
//
//

import UIKit
import Combine

enum MainTabBarTransition: Transition {
    
}

final class MainTabBarModuleBuilder {
    class func build(container: AppContainer, viewControllers: [UIViewController]) -> Module<MainTabBarTransition, UIViewController> {
        let model = MainTabMabModelImpl(userService: container.userService, adsService: container.advertisementService)
        let viewModel = MainTabBarViewModel(model: model)
        let viewController = MainTabBarViewController(viewModel: viewModel, viewControllers: viewControllers)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
