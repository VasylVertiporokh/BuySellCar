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
    case vehicleData
}

final class AdsVehicleDetailsModuleBuilder {
    class func build(container: AppContainer, flow: AddAdvertisementFlow) -> Module<AdsVehicleDetailsTransition, UIViewController> {
        let viewModel = AdsVehicleDetailsViewModel(
            addAdvertisementModel: container.addAdvertisementModel,
            flow: flow
        )
        let viewController = AdsVehicleDetailsViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
