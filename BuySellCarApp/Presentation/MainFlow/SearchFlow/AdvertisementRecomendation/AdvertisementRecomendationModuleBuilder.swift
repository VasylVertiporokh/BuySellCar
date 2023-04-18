//
//  AdvertisementRecomendationModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.03.2023.
//

import UIKit
import Combine

enum AdvertisementRecomendationTransition: Transition {
    case showResult(AdvertisementModel)
}

final class AdvertisementRecomendationModuleBuilder {
    class func build(container: AppContainer) -> Module<AdvertisementRecomendationTransition, UIViewController> {
        let advertisementModel = AdvertisementModelImpl(advertisementService: container.advertisementService)
        let viewModel = AdvertisementRecommendationViewModel(advertisementModel: advertisementModel)
        let viewController = AdvertisementRecommendationViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
