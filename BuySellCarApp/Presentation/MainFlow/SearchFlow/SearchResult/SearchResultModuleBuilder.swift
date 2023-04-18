//
//  SearchResultModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.03.2023.
//

import UIKit
import Combine

enum SearchResultTransition: Transition {
    
}

final class SearchResultModuleBuilder {
    class func build(container: AppContainer, model: AdvertisementModel) -> Module<SearchResultTransition, UIViewController> {
        let viewModel = SearchResultViewModel(advertisementModel: model)
        let viewController = SearchResultViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
