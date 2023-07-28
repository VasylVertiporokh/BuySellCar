//
//  FuelTypeModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/07/2023.
//

import UIKit

struct FuelTypeModel: Hashable, SearchableModelProtocol {
    let fuelType: String
    var isSelected: Bool = false
    
    var searchParam: SearchParam {
        .init(key: .fuelType, value: .equalToString(stringValue: fuelType))
    }
    
    static func fuelTypes() -> [Self] {
        return [
            .init(fuelType: "Petrol"),
            .init(fuelType: "Electro"),
            .init(fuelType: "Hybrid"),
            .init(fuelType: "Disel"),
            .init(fuelType: "LPG"),
            .init(fuelType: "Ethanol"),
            .init(fuelType: "Hydrogen"),
            .init(fuelType: "Other")
        ]
    }
}
