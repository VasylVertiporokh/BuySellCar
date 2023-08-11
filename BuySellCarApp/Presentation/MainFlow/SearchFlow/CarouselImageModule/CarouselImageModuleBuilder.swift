//
//  CarouselImageModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 08/08/2023.
//

import UIKit
import Combine

enum CarouselImageTransition: Transition {
    
}

final class CarouselImageModuleBuilder {
    class func build(
        container: AppContainer,
        model: CarouselImageView.ViewModel) -> Module<CarouselImageTransition, UIViewController> {
        let viewModel = CarouselImageViewModel(model: model)
        let viewController = CarouselImageViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
