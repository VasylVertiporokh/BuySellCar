//
//  UIAction+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 15.03.2023.
//

import UIKit

extension UIAction {
    func setFont(_ font: UIFont) {
        let attributes = [NSAttributedString.Key.font: font]
        self.setValue(NSAttributedString(string: title, attributes: attributes), forKey: "attributedTitle")
    }
}
