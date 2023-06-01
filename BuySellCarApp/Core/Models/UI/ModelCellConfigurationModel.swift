//
//  ModelCellConfigurationModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import Foundation

struct ModelCellConfigurationModel: Hashable {
    let modelName: String
    let brandID: String
    
    init(brandDomainModel: ModelsDomainModel) {
        self.modelName = brandDomainModel.modelName
        self.brandID = brandDomainModel.brandID
    }
}
