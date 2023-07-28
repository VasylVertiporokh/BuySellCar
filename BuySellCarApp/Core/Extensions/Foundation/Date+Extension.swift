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

extension Date {
    var millisecondsSince1970: Int {
        Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}

extension TimeInterval {
    var miliseconds: Int {
        Int((self * 1000).rounded())
    }
}

extension Int {
    var seconds: TimeInterval {
        TimeInterval(self) / 1000
    }
}
