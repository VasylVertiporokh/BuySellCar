//
//  ModelCellConfigurationModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import Foundation

struct ModelCellConfigurationModel: Hashable, SearchableModelProtocol {
    let modelName: String
    let brandID: String
    
    var isSelected: Bool = false
    var searchParam: SearchParam {
        .init(key: .transportModel, value: .equalToString(stringValue: modelName))
    }
    
    init(brandDomainModel: ModelsDomainModel) {
        self.modelName = brandDomainModel.modelName
        self.brandID = brandDomainModel.brandID
        self.isSelected = brandDomainModel.isSelected
    }
}
