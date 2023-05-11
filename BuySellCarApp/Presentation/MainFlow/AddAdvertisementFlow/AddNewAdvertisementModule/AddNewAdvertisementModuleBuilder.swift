//
//  AddNewAdvertisementModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 11.05.2023.
//

import UIKit
import Combine

enum AddNewAdvertisementTransition: Transition {
    
}

final class AddNewAdvertisementModuleBuilder {
    class func build(container: AppContainer) -> Module<AddNewAdvertisementTransition, UIViewController> {
        let viewModel = AddNewAdvertisementViewModel()
        let viewController = AddNewAdvertisementViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
