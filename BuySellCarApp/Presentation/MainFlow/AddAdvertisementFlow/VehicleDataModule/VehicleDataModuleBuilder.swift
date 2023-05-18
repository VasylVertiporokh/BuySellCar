//
//  VehicleDataModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import UIKit
import Combine

enum VehicleDataTransition: Transition {
    case showBrands
    case showModels
    case showRegistrationDate
    case showFuelType
    case showBodyColor
}

final class VehicleDataModuleBuilder {
    class func build(container: AppContainer) -> Module<VehicleDataTransition, UIViewController> {
        let viewModel = VehicleDataViewModel(addAdvertisementModel: container.addAdvertisementModel)
        let viewController = VehicleDataViewController(viewModel: viewModel)
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
