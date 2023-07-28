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
    case showBrands
    case showModels
    case popModule
}

final class SearchAdvertisementModuleBuilder {
    class func build(container: AppContainer, flow: SearchFlow) -> Module<SearchAdvertisementTransition, UIViewController> {
        let viewModel = SearchAdvertisementViewModel(advertisementModel: container.searchAdvertisementModel, flow: flow)
        let viewController = SearchAdvertisementViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
