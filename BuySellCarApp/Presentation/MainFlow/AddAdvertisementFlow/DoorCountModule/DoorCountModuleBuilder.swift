//
//  DoorCountModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/09/2023.
//

import UIKit
import Combine
import SwiftUI

enum DoorCountTransition: Transition {
    
}

final class DoorCountModuleBuilder {
    class func build(container: AppContainer) -> Module<DoorCountTransition, UIViewController> {
        let viewModel = DoorCountViewModel(addAdvertisementModel: container.addAdvertisementModel)
        let viewController = UIHostingController(rootView: DoorCountView(viewModel: viewModel))
        viewController.title = "Door count"
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
