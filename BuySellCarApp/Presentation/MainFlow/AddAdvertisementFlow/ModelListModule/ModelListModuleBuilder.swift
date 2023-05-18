//
//  ModelListModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 17.05.2023.
//

import UIKit
import Combine

enum ModelListTransition: Transition {
    case popToPreviousModule
}

final class ModelListModuleBuilder {
    class func build(container: AppContainer) -> Module<ModelListTransition, UIViewController> {
        let viewModel = ModelListViewModel(addAdvertisementModel: container.addAdvertisementModel)
        let viewController = ModelListViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
