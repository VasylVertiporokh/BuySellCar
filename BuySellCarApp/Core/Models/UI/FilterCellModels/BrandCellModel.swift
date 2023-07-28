//
//  BrandCellModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/07/2023.
//

import UIKit

struct BrandCellModel: Hashable {
    var isSelected: Bool = false
    let logoImage: UIImage
    let brandName: String
    let id: String
    
    static func basicBrands() -> [Self] {
        return [
            .init(logoImage: Assets.bmwLogo.image, brandName: "BMW", id: "4"),
            .init(logoImage: Assets.volkswagenLogo.image, brandName: "Volkswagen",id: "52"),
            .init(logoImage: Assets.audiLogo.image, brandName: "Audi", id: "2"),
            .init(logoImage: Assets.mercedesLogo.image, brandName: "Mercedes", id: "32"),
            .init(logoImage: Assets.fordLogo.image, brandName: "Ford", id: "17"),
            .init(logoImage: Assets.fiatLogo.image, brandName: "Fiat", id: "16"),
            .init(logoImage: Assets.renaultLogo.image, brandName: "Renault", id: "40"),
            .init(logoImage: Assets.nissanLogo.image, brandName: "Nissan", id: "35")
        ]
    }
}
