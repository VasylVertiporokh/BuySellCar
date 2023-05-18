//
//  FuelTypeListModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import UIKit
import Combine

enum FuelTypeListTransition: Transition {
    case popToPreviousModule
}

final class FuelTypeListModuleBuilder {
    class func build(container: AppContainer) -> Module<FuelTypeListTransition, UIViewController> {
        let viewModel = FuelTypeListViewModel(addAdvertisementModel: container.addAdvertisementModel)
        let viewController = FuelTypeListViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
