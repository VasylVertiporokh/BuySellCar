//
//  FirstRedistrationModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 17.05.2023.
//

import UIKit
import Combine

enum FirstRegistrationTransition: Transition {
    
}

final class FirstRedistrationModuleBuilder {
    class func build(container: AppContainer) -> Module<FirstRegistrationTransition, UIViewController> {
        let viewModel = FirstRegistrationViewModel(addAdvertisementModel: container.addAdvertisementModel)
        let viewController = FirstRegistrationViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
