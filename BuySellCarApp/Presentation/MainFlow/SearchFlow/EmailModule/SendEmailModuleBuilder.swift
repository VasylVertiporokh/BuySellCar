//
//  SendEmailModuleBuilder.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 11/08/2023.
//

import UIKit
import SwiftUI

enum SendEmailModuleTransition: Transition {
    case dismiss
}

final class SendEmailModuleBuilder {
    class func build(
        container: AppContainer,
        adsDomainModel: AdvertisementDomainModel
    ) -> Module<SendEmailModuleTransition, UIViewController> {
        let viewModel = SendEmailViewModel(adsDomainModel: adsDomainModel, emailService: container.emailService)
        let viewController = UIHostingController(rootView: SendEmailView(viewModel: viewModel))
        return Module(viewController: viewController, transitionPublisher: viewModel.transitionPublisher)
    }
}
