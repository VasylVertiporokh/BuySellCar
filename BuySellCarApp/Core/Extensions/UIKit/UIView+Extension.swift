//
//  UIView+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 21.03.2023.
//

import UIKit

extension UIView {
    func dropShadow() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 8
    }
    
    func dropShadow(shadowColor: UIColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }
}
