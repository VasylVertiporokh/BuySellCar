//
//  BrandListModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import UIKit
import Combine

enum BrandListTransition: Transition {
    case popToPreviousModule
}

final class BrandListModuleBuilder {
    class func build(container: AppContainer) -> Module<BrandListTransition, UIViewController> {
        let viewModel = BrandListViewModel(addAdvertisementModel: container.addAdvertisementModel)
        let viewController = BrandListViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
