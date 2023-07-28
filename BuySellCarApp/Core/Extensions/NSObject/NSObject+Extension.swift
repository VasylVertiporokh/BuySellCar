//
//  NSObject+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 19.04.2023.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
