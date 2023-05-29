//
//  UIAlertAction+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 22.05.2023.
//

import UIKit

extension UIAlertAction {
    func setActionTitleColor(_ color: UIColor) {
        self.setValue(color, forKey: "titleTextColor")
    }
}
