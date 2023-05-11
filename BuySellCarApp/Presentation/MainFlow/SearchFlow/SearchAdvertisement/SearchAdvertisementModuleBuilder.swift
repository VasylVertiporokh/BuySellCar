//
//  SearchAdvertisementModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.04.2023.
//

import UIKit
import Combine

enum SearchAdvertisementTransition: Transition {
    case showResults
}

final class SearchAdvertisementModuleBuilder {
    class func build(container: AppContainer, model: AdvertisementModel) -> Module<SearchAdvertisementTransition, UIViewController> {
        let viewModel = SearchAdvertisementViewModel(advertisementModel: model)
        let viewController = SearchAdvertisementViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
