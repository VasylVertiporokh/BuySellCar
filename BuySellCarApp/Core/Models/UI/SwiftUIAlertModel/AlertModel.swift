//
//  AlertModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 16/08/2023.
//

import Foundation

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
