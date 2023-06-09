//
//  ModelsDomainModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import Foundation

struct ModelsDomainModel: SearchableModelProtocol, Hashable {
    let brandID: String
    let modelName: String
    var isSelected: Bool = false
    var searchParam: SearchParam {
        .init(key: .transportModel, value: .equalToString(stringValue: modelName))
    }
    
    // MARK: - Init
    init(modelResponseModel: ModelResponseModel) {
        self.brandID = modelResponseModel.brandID
        self.modelName = modelResponseModel.modelName
    }
}
