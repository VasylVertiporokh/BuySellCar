//
//  File.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 22.03.2023.
//

import Foundation

struct CreateAccountValidationForm: Equatable {
    var email: ValidationState = .notChecked
    var name: ValidationState = .notChecked
    var phone: ValidationState = .notChecked
    var password: ValidationState = .notChecked
    var confirmPassword: ValidationState = .notChecked
    
    var isAllValid: Bool {
        email.isValid && name.isValid  && phone.isValid && password.isValid && confirmPassword.isValid
    }
}
