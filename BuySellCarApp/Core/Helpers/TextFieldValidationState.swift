//
//  TextFieldValidationState.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 22.03.2023.
//

import Foundation

enum ValidationState {
    case notChecked
    case valid
    case invalid
}

// MARK: - Internal extension
extension ValidationState {
    var isValid: Bool {
        self == .valid
    }
    
    var isInvalid: Bool {
        self == .invalid
    }
}
