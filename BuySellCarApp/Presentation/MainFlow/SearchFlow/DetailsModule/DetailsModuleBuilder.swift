//
//  DetailsModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 01/08/2023.
//

import UIKit
import Combine

enum DetailsTransition: Transition {
    
}

final class DetailsModuleBuilder {
    class func build(container: AppContainer) -> Module<DetailsTransition, UIViewController> {
        let viewModel = DetailsViewModel()
        let viewController = DetailsViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
