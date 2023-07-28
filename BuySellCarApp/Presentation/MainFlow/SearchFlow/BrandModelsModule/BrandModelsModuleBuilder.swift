//
//  BrandModelsModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 30.05.2023.
//

import UIKit
import Combine

enum BrandModelsTransition: Transition {
    case dissmiss
}

final class BrandModelsModuleBuilder {
    class func build(container: AppContainer) -> Module<BrandModelsTransition, UIViewController> {
        let viewModel = BrandModelsViewModel(advertisementModel: container.searchAdvertisementModel)
        let viewController = BrandModelsViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
