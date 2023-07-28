//
//  BrandCellConfigurationModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import Foundation

struct BrandCellConfigurationModel: Hashable {
    let brandName: String
    let id: String
    
    init(brandDomainModel: BrandDomainModel) {
        self.brandName = brandDomainModel.name
        self.id = brandDomainModel.id
    }
}
