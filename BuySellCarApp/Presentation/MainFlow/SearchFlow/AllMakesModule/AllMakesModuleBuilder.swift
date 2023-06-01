//
//  AllMakesModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.05.2023.
//

import UIKit
import Combine

enum AllMakesTransition: Transition {
    case showModels
}

final class AllMakesModuleBuilder {
    class func build(container: AppContainer) -> Module<AllMakesTransition, UIViewController> {
        let viewModel = AllMakesViewModel(advertisementModel: container.searchAdvertisementModel)
        let viewController = AllMakesViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
