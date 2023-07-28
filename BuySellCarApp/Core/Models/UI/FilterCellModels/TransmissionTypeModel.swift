//
//  TransmissionTypeModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/07/2023.
//

import UIKit

struct TransmissionTypeModel: Hashable, SearchableModelProtocol {
    let transmissionType: String
    var isSelected: Bool = false
    
    var searchParam: SearchParam {
        .init(key: .transmissionType, value: .equalToString(stringValue: transmissionType))
    }
    
    static func transmissionTypes() -> [Self] {
        return [
            .init(transmissionType: "Manual"),
            .init(transmissionType: "Automatic"),
            .init(transmissionType: "Semi-automatic")
        ]
    }
}
