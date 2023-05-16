//
//  ModelsDomainModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import Foundation

struct ModelsDomainModel {
    let brandID: String
    let modelName: String
    
    init(modelResponseModel: ModelResponseModel) {
        self.brandID = modelResponseModel.brandID
        self.modelName = modelResponseModel.modelName
    }
}
