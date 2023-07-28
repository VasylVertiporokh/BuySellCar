//
//  ValidationForms.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 05.06.2023.
//

import Foundation

// MARK: - SignIn
struct SignInValidationForm {
    var email: ValidationState = .notChecked
    var password: ValidationState = .notChecked
    
    var isAllValid: Bool {
        email.isValid && password.isValid
    }
}

// MARK: - Create account
struct CreateAccountValidationForm {
    var email: ValidationState = .notChecked
    var name: ValidationState = .notChecked
    var phone: ValidationState = .notChecked
    var password: ValidationState = .notChecked
    var confirmPassword: ValidationState = .notChecked
    
    var isAllValid: Bool {
        email.isValid && name.isValid  && phone.isValid && password.isValid && confirmPassword.isValid
    }
}

// MARK: - Edit profile
struct EditProfileValidation {
    var name: ValidationState = .valid
    var phoneNumber: ValidationState = .valid
    
    var isAllValid: Bool {
        name.isValid  && phoneNumber.isValid
    }
}
