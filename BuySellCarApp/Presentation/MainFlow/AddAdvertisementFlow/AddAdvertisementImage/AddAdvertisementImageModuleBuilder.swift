//
//  AddAdvertisementImageModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.05.2023.
//

import UIKit
import Combine

enum AddAdvertisementImageTransition: Transition {
    
}

final class AddAdvertisementImageModuleBuilder {
    class func build(container: AppContainer, flow: AddAdvertisementFlow) -> Module<AddAdvertisementImageTransition, UIViewController> {
        let viewModel = AddAdvertisementImageViewModel(
            addAdvertisementModel: container.addAdvertisementModel,
            flow: flow
        )
        let viewController = AddAdvertisementImageViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
