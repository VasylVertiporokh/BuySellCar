//
//  Int+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 31.03.2023.
//

import Foundation

extension Int {
    var incrementByOne: Self {
        self + 1
    }
    
    var isEquallyOne: Bool {
        self == 1
    }
    
    var isZero: Bool {
        self == .zero
    }
        
    func toDateType(dateType: String) -> String {
        let millisecondsToDate = Date(milliseconds: Int64(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateType
        let result = dateFormatter.string(from: millisecondsToDate)
        return result
    }
}
