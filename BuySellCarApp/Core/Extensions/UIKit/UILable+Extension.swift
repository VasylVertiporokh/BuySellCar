//
//  UILable+Extension.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 31/08/2023.
//

import UIKit

enum SkeletonPlaceholderValue: String {
    case short = "----"
    case medium = "--------"
    case long = "--------------"
}

extension UILabel {
    func setSkeletonPlaceholder(_ value: SkeletonPlaceholderValue) {
        self.text = value.rawValue
    }
}
