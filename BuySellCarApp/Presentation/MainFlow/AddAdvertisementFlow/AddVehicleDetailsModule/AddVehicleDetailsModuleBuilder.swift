//
//  AddVehicleDetailsModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 23/09/2023.
//

import UIKit
import Combine
import SwiftUI

enum AddVehicleDetailsTransition: Transition {
    case showModel
    case showFuelType
    case showBodyColor
    case showNumberOfSeats
    case showNumberOfDoor
    case showBodyType
    case showCondition
}

final class AddVehicleDetailsModuleBuilder {
    class func build(container: AppContainer) -> Module<AddVehicleDetailsTransition, UIViewController> {
        let viewModel = AddVehicleDetailsViewModel(addAdvertisementModel: container.addAdvertisementModel)
        let viewController = UIHostingController(rootView: AddVehicleDetailsView(viewModel: viewModel))
        viewController.title = "Vehicle details"
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
