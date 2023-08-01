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
    case startSearch(AdvertisementModel)
    case showDetails
}

final class AdvertisementRecomendationModuleBuilder {
    class func build(container: AppContainer) -> Module<AdvertisementRecomendationTransition, UIViewController> {
        let viewModel = AdvertisementRecommendationViewModel(advertisementModel: container.searchAdvertisementModel)
        let viewController = AdvertisementRecommendationViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
