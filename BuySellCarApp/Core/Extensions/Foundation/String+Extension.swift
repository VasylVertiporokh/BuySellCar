//
//  String+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 31.05.2023.
//

import Foundation

extension String {
    func toSimpleNumberFormat() -> Self {
        let numberFormatter = NumberFormatter()
        var formattedString = ""
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "
        numberFormatter.groupingSize = 3
        
        if let number = numberFormatter.number(from: self.replacingOccurrences(of: " ", with: "")) {
            formattedString = numberFormatter.string(from: number) ?? ""
        }
        return formattedString
    }
}
