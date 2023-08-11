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
    class func build(viewControllers: [UIViewController]) -> Module<MainTabBarTransition, UIViewController> {
        let viewModel = MainTabBarViewModel()
        let viewController = MainTabBarViewController(viewModel: viewModel, viewControllers: viewControllers)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
