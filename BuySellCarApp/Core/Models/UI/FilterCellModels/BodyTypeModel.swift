//
//  BodyTypeModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/07/2023.
//

import UIKit

struct BodyTypeModel: Hashable, SearchableModelProtocol {
    let bodyTypeImage: UIImage
    let bodyTypeLabel: String
    var isSelected: Bool = false
    
    var searchParam: SearchParam {
        .init(key: .bodyType, value: .equalToString(stringValue: bodyTypeLabel))
    }
    
    static func basicBodyTypes() -> [Self] {
        return [
            .init(bodyTypeImage: Assets.compactBody.image, bodyTypeLabel: "Compact"),
            .init(bodyTypeImage: Assets.sedanBody.image, bodyTypeLabel: "Sedan"),
            .init(bodyTypeImage: Assets.stationWagonBody.image, bodyTypeLabel: "Station wagon"),
            .init(bodyTypeImage: Assets.cabrioBody.image, bodyTypeLabel: "Cabrio"),
            .init(bodyTypeImage: Assets.suvBody.image, bodyTypeLabel: "SUV"),
            .init(bodyTypeImage: Assets.vanBody.image, bodyTypeLabel: "Van"),
            .init(bodyTypeImage: Assets.transporterBody.image, bodyTypeLabel: "Transporter"),
            .init(bodyTypeImage: Assets.hatchbackBody.image, bodyTypeLabel: "Hatchback")
        ]
    }
}
