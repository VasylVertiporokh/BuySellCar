//
//  VehicleConditionModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 02/10/2023.
//

import UIKit
import Combine
import SwiftUI

enum VehicleConditionTransition: Transition {
    
}

final class VehicleConditionModuleBuilder {
    class func build(container: AppContainer) -> Module<VehicleConditionTransition, UIViewController> {
        let viewModel = VehicleConditionViewModel(addAdvertisementModel: container.addAdvertisementModel)
        let viewController = UIHostingController(rootView: VehicleConditionView(viewModel: viewModel))
        viewController.title = "Condition"
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
