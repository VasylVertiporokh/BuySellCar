//
//  BodyTypeModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/09/2023.
//

import UIKit
import SwiftUI
import Combine

enum BodyTypeTransition: Transition {
    
}

final class BodyTypeModuleBuilder {
    class func build(container: AppContainer) -> Module<BodyTypeTransition, UIViewController> {
        let viewModel = BodyTypeViewModel(addAdvertisementModel: container.addAdvertisementModel)
        let viewController = UIHostingController(rootView: BodyTypeView(viewModel: viewModel))
        viewController.title = "Body type"
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
