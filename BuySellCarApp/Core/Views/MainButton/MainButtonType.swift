//
//  MainButtonType.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 27.02.2023.
//

import UIKit


enum MainButtonType {
    case login
    case logout
    case startSearch
    case restorePassword
    case createAccount
    case back
}

extension MainButtonType {
    var buttonTitle: String {
        switch self {
        case .login:
            return "Login"
        case .logout:
            return "Logout"
        case .startSearch:
            return "Start Search"
        case .restorePassword:
            return "Restore"
        case.createAccount:
            return "Create account"
        case .back:
            return "Back"
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .login:
            return Colors.buttonDarkGray.color
        case .logout:
            return .red
        case .startSearch:
            return Colors.buttonDarkGray.color
        case .restorePassword:
            return Colors.buttonDarkGray.color
        case.createAccount:
            return Colors.buttonDarkGray.color
        case .back:
            return Colors.buttonDarkGray.color
        }
    }
    
    var titleColor: UIColor {
        return .white
    }
    
    var titleFont: UIFont {
        return FontFamily.Montserrat.semiBold.font(size: 16)
    }
}
