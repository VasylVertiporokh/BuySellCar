//
//  BodyColorModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import UIKit
import Combine

enum BodyColorTransition: Transition {
    case popToPreviousModule
}

final class BodyColorModuleBuilder {
    class func build(container: AppContainer) -> Module<BodyColorTransition, UIViewController> {
        let viewModel = BodyColorViewModel(addAdvertisementModel: container.addAdvertisementModel)
        let viewController = BodyColorViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
