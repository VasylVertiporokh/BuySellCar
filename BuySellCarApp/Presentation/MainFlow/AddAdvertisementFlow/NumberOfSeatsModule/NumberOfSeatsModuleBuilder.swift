//
//  NumberOfSeatsModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 27/09/2023.
//

import UIKit
import Combine
import SwiftUI

enum NumberOfSeatsTransition: Transition {
    
}

final class NumberOfSeatsModuleBuilder {
    class func build(container: AppContainer) -> Module<NumberOfSeatsTransition, UIViewController> {
        let viewModel = NumberOfSeatsViewModel(addAdvertisementModel: container.addAdvertisementModel)
        let viewController = UIHostingController(rootView: NumberOfSeatsView(viewModel: viewModel))
        viewController.title = "Number of seats"
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
