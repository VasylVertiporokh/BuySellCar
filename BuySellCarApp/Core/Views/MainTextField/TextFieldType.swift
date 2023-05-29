//
//  TextFieldType.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 27.02.2023.
//

import UIKit

enum TextFieldType {
    case nickname
    case password
    case confirmPassword
    case name
    case email
    case editable
    case plain
}

// MARK: - Internal extension
extension TextFieldType {
    var keyboardType: UIKeyboardType {
        switch self {
        case .name, .plain:
            return .alphabet
        case .password, .confirmPassword:
            return .default
        case .email, .nickname, .editable:
            return .emailAddress
        }
    }
    
    var leftImage: UIImage? {
        switch self {
        case .nickname:
            return Assets.userIcon.image
        case .password:
            return Assets.passwordIcon.image
        case .confirmPassword:
            return Assets.keyIcon.image
        case .name:
            return Assets.addUserIcon.image
        case .email:
            return Assets.emailIcon.image
        case .editable, .plain:
            return nil
        }
    }
    
    var rightImage: UIImage? {
        var imageName: String = ""
        switch self {
        case .nickname:
            imageName = "multiply.circle"
        case .password:
            imageName = "eye.slash"
        case .confirmPassword:
            imageName = "eye.slash"
        case .editable:
            return Assets.editIcon.image
        case .name:
            return nil
        case .email, .plain:
            return nil
        }
        return UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
    }
    
    var placeholder: NSAttributedString {
        var text: String!
        switch self {
        case .nickname:        text = "Nickname (e-mail address)"
        case .password:        text = "Password"
        case .confirmPassword: text = "Confirm password"
        case .name:            text = "Name"
        case .email:           text = "Email"
        case .editable:        text = "Field not valid"
        case .plain:           text = ""
        }
        
        let attibutes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: FontFamily.Montserrat.regular.font(size: 12)
        ]
        
        return NSAttributedString(string: text, attributes: attibutes)
    }
    
    var needsSecureTextEntry: Bool {
        switch self {
        case .password: return true
        case .confirmPassword: return true
        default: return false
        }
    }
    
    var errorMessage: String {
        switch self {
        case .nickname:
            return "Invalid nickname"
        case .password:
            return "Invalid password"
        case .confirmPassword:
            return "Passwords are different"
        case .name:
            return "Invalid name"
        case .email:
            return "Invalid email"
        case .editable, .plain:
            return "Field is empty"
        }
    }
}
