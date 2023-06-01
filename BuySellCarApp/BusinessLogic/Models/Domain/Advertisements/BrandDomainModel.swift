//
//  BrandDomainModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 15.05.2023.
//

import Foundation

struct BrandDomainModel {
    let dataType: VehicleDataType = .make
    let id: String
    let name: String
    var isSelected: Bool = false
    
    init(brandResponseModel: BrandResponseModel) {
        self.id = brandResponseModel.id
        self.name = brandResponseModel.name
    }
}
