//
//  EditProfileValidation.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.03.2023.
//

import Foundation

struct EditProfileValidation {
    var name: ValidationState = .valid
    var phoneNumber: ValidationState = .valid
    
    var isAllValid: Bool {
        name.isValid  && phoneNumber.isValid
    }
}
