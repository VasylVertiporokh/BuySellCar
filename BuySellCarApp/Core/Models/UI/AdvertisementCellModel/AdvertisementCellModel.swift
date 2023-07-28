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
    let created: Int
    
    // MARK: - Init from AdvertisementCellModel
    init(model: AdvertisementDomainModel) {
        brandName = model.transportName
        brandModel = model.transportModel
        price = model.price
        mileage = model.mileage
        power = model.power
        numberOfOwners = model.numberOfSeats
        fuelConsumption = model.avarageFuelConsumption
        year = model.yearOfManufacture
        condition = model.condition.rawValue
        fuelType = model.fuelType.rawValue
        color = model.bodyColor.rawValue
        sellerName = model.sellerName
        location = model.location
        objectID = model.objectID
        imageArray = model.images?.carImages ?? [""]
        created = model.created
    }
}
