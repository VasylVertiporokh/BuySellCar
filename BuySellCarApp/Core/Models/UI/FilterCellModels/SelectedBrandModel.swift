//
//  SelectedBrandModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/07/2023.
//

import Foundation

struct SelectedBrandModel: Hashable, SearchableModelProtocol {
    let id: String
    let brand: String
    var model: [String] = []
    var isSelected: Bool = true
    var brandModelSearchParams: [SearchParam] = []
    var searchParam: SearchParam {
        .init(key: .transportName, value: .equalToString(stringValue: brand))
    }
    
    init(id: String, brand: String, model: [String] = [], isSelected: Bool = true, brandModelSearchParams: [SearchParam] = []) {
        self.id = id
        self.brand = brand
        self.model = model
        self.isSelected = isSelected
        self.brandModelSearchParams = brandModelSearchParams
    }
}
