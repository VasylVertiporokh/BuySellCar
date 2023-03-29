//
//  AdvertisementCellModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.03.2023.
//

import Foundation

struct AdvertisementCellModel: Hashable {
    let brandName: String
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
    let location: String
    let objectID: String
    
    // MARK: - Init from AdvertisementCellModel
    init(model: AdvertisementResponseModel) {
        brandName = model.transportName
        price = model.price
        mileage = model.mileage
        power = model.power
        numberOfOwners = model.numberOfSeats
        fuelConsumption = model.avarageFuelConsumption
        year = model.yearOfManufacture
        condition = model.condition.rawValue
        fuelType = model.fuelType.rawValue
        color = model.bodyColor
        sellerName = "Alex" // TODO: - add this fields
        location = "Berlin"
        objectID = model.objectID
    }
}
