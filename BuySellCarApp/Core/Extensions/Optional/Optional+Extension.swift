//
//  Optional+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 21.03.2023.
//

import Foundation

extension Optional where Wrapped == String {
    var isNotEmpty: Bool {
        return !(self?.isEmpty ?? true)
    }
    
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

extension Optional {
    var isNil: Bool {
        return self == nil
    }
}

extension Optional where Wrapped == Int {
    var isNilOrZero: Bool {
        return self == nil || self == 0
    }
}
