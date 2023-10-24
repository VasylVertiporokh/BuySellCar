//
//  AlertModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 16/08/2023.
//

import Foundation
import UIKit

/// SwiftUI aler model
struct AlertModel: Identifiable {
    private(set) var id: Int
    let buttonTitle: String
    let title: String
    let message: String
    let action: (() -> Void)?
    
    // MARK: - Init
    init(buttonTitle: String = "OK", title: String, message: String, action: (() -> Void)? = nil) {
        self.id = Int.random(in: 1...10)
        self.buttonTitle = buttonTitle
        self.title = title
        self.message = message
        self.action = action
    }
}

/// UIKit aler model
struct UIAlertControllerModel {
    var preferredStyle: UIAlertController.Style = .alert
    var confirmActionStyle: UIAlertAction.Style = .default
    var discardActionStyle: UIAlertAction.Style = .default
    var title: String?
    var message: String?
    var confirmButtonTitle: String? = Localization.ok
    var discardButtonTitle: String? = Localization.cancel
    var confirmAction: (() -> Void)?
    var discardAction: (() -> Void)?
}
