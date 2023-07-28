//
//  AdsVehicleDetailsModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import UIKit
import Combine

enum AdsVehicleDetailsTransition: Transition {
    case showAddAdsPhotos
    case showRegistrationDate
    case popToRoot
}

final class AdsVehicleDetailsModuleBuilder {
    class func build(container: AppContainer) -> Module<AdsVehicleDetailsTransition, UIViewController> {
        let viewModel = AdsVehicleDetailsViewModel(addAdvertisementModel: container.addAdvertisementModel)
        let viewController = AdsVehicleDetailsViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
