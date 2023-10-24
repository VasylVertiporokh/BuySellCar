//
//  AdvertisementCellModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.04.2023.
//

import Foundation

struct AdvertisementCellModel: Hashable {
    let brandName: String
    let brandModel: String
    let price: Int
    let mileage: Int
    let power: Int
    var numberOfOwners: Int?
    let fuelConsumption: Double
    let year: Int
    let condition: String
    let fuelType: String
    let color: String
    let sellerName: String
    var location: String? = ""
    let objectID: String
    let imageArray: [String]
    let imagePreviewUrl: String?
    let created: Int
    let isFromDataBase: Bool
    
    // MARK: - Init from AdvertisementCellModel
    init(model: AdvertisementDomainModel) {
        self.brandName = model.transportName
        self.brandModel = model.transportModel
        self.price = model.price
        self.mileage = model.mileage
        self.power = model.power
        self.numberOfOwners = model.numberOfSeats.rawValue
        self.fuelConsumption = model.avarageFuelConsumption
        self.year = model.yearOfManufacture
        self.condition = model.condition.rawValue
        self.fuelType = model.fuelType.rawValue
        self.color = model.bodyColor.rawValue
        self.sellerName = model.sellerName
        self.location = model.location
        self.objectID = model.objectID
        self.imageArray = model.adsImageUrlArray ?? []
        self.imagePreviewUrl = model.previewImageUrl
        self.created = model.created
        self.isFromDataBase = model.isDatabaseModel
    }
}
