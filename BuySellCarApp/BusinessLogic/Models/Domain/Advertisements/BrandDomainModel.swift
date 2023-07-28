//
//  BrandDomainModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 15.05.2023.
//

import Foundation

struct BrandDomainModel: SearchableModelProtocol {
    let id: String
    let name: String
    var isSelected: Bool = false
    
    var searchParam: SearchParam {
        .init(key: .transportName, value: .equalToString(stringValue: name))
    }
    
    init(brandResponseModel: BrandResponseModel) {
        self.id = brandResponseModel.id
        self.name = brandResponseModel.name
    }
}
