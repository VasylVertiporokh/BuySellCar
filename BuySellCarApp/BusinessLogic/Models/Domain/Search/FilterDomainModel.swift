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
    let year = TechnicalSpecCellModel.year()
    let millage = TechnicalSpecCellModel.millage()
    let power = TechnicalSpecCellModel.power()
    var bodyType = BodyTypeModel.basicBodyTypes()
    var fuelType = FuelTypeModel.fuelTypes()
    var transmissionType = TransmissionTypeModel.transmissionTypes()
    var maxYearSearchParam: SearchParam?
    var minYearSearchParam: SearchParam?
    var minPowerSearchParam: SearchParam?
    var maxPowerSearchParam: SearchParam?
    var minMillageSearchParam: SearchParam?
    var maxMillageSearchParam: SearchParam?
}
