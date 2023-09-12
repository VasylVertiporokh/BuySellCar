//
//  FavoriteModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 21/08/2023.
//

import SwiftUI
import Combine

enum FavoriteTransition: Transition {
    case showDetails(AdvertisementDomainModel)
}

final class FavoriteModuleBuilder {
    class func build(container: AppContainer) -> Module<FavoriteTransition, UIViewController> {
        let viewModel = FavoriteViewModel(
            userService: container.userService,
            favoriteStorageService: container.favoriteStorageService
        )
        let viewController = UIHostingController(rootView: FavoriteView(viewModel: viewModel))
        viewController.title = "Favorite"
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
