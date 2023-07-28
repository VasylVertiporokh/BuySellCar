//
//  SearchAdvertisementDomainModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 14.06.2023.
//

import Foundation

struct FilterDomainModel {
    var allBrands: [BrandDomainModel] = []
    var brandModels: [ModelsDomainModel] = []
    var selectedBrand: [SelectedBrandModel] = []
    let basicBrand = BrandCellModel.basicBrands()
    var year = TechnicalSpecCellModel.year()
    var millage = TechnicalSpecCellModel.millage()
    var power = TechnicalSpecCellModel.power()
    var bodyType = BodyTypeModel.basicBodyTypes()
    var fuelType = FuelTypeModel.fuelTypes()
    var transmissionType = TransmissionTypeModel.transmissionTypes()
}
