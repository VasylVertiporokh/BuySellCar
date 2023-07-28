//
//  TechnicalSpecCellModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/07/2023.
//

import Foundation

struct TechnicalSpecCellModel: Hashable {
    // MARK: - Nested entity
    struct SelectedRange: Hashable {
        var minRangeValue: Double?
        var maxRangeValue: Double?
    }
    
    // MARK: - Properties
    private let uuid = UUID().uuidString
    private let paramType: RangeParametersType
    let inRange: RangeView.Range
    let rangeStep: Double
    var minSelected: Double?
    var maxSelected: Double?
    
    var minSearchValue: SearchParam? {
        switch paramType {
        case .registration:
            return minSelected.map { .init(key: .yearOfManufacture, value: .greaterOrEqualTo(intValue: Int($0))) }
        case .millage:
            return minSelected.map { .init(key: .mileage, value: .greaterOrEqualTo(intValue: Int($0))) }
        case .power:
            return minSelected.map { .init(key: .power, value: .greaterOrEqualTo(intValue: Int($0))) }
        }
    }
    
    var maxSearchValue: SearchParam? {
        switch paramType {
        case .registration:
            return maxSelected.map { .init(key: .yearOfManufacture, value: .lessOrEqualTo(intValue: Int($0))) }
        case .millage:
            return maxSelected.map { .init(key: .mileage, value: .lessOrEqualTo(intValue: Int($0))) }
        case .power:
            return maxSelected.map { .init(key: .power, value: .lessOrEqualTo(intValue: Int($0))) }
        }
    }
    
    // MARK: - TechnicalSpecCell models
    static func year() -> Self {
        let year = Calendar.current.component(.year, from: Date())
        let yearRange: RangeView.Range = .init(lowerBound: 1920, upperBound: Double(year))
        return .init(paramType: .registration, inRange: yearRange, rangeStep: 1)
    }
    
    static func millage() -> Self {
        let millageRange: RangeView.Range = .init(lowerBound: 0, upperBound: 250000)
        return .init(paramType: .millage, inRange: millageRange, rangeStep: 500)
    }

    static func power() -> Self {
        let powerRange: RangeView.Range = .init(lowerBound: 20, upperBound: 1000)
        return .init(paramType: .power, inRange: powerRange, rangeStep: 10)
    }
}
