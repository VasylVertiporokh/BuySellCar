//
//  Date+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 17.05.2023.
//

import Foundation

enum DateFormat: String {
    case monthYear = "MM-yyyy"
    case year = "yyyy"
    case yearMonthDay = "yyyy-MM-dd"
}

extension Date {
    func convertToString(format: DateFormat) -> String {
        var stringDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        stringDate = dateFormatter.string(from: self)
        return stringDate
    }

    var convertToIntYear: Int {
        let calendar = Calendar.current
        let intYear = calendar.component(.year, from: self)
        return intYear
    }
}
