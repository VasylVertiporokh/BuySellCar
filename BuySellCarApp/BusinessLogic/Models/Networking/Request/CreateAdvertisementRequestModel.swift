//
//  CreateAdvertisementRequestModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 24.05.2023.
//

import Foundation

struct CreateAdvertisementRequestModel: Encodable {
    var ownerId: String?
    var mileage: Int?
    var fuelType: FuelType?
    let transportName: String?
    var location: String? = ""
    let bodyColor: CarColor?
    let sellerType: SellerType
    let description: String = ""
    let price: Int?
    let interiorFittings: CarColor = .white
    let numberOfSeats: Int = 5
    var yearOfManufacture: Int?
    let bodyType: BodyType?
    let transmissionType: TransmissionType = .manual
    let shortDescription: String
    let avarageFuelConsumption: Double = 5.2
    var images: AdvertisementImages?
    var condition: Condition = .used
    let transportModel: String?
    let doorCount: Int = 5
    let interiorColor: CarColor = .gray
    var power: Int?
    var sellerName: String?
    
    init(domainModel: AddAdvertisementDomainModel) {
        self.mileage = domainModel.mainTechnicalInfo?.millage
        self.price = domainModel.mainTechnicalInfo?.price
        self.power = domainModel.mainTechnicalInfo?.price
        self.ownerId = domainModel.ownerId
        self.fuelType = domainModel.fuelType
        self.transportName = domainModel.make
        self.bodyColor = domainModel.bodyColor
        self.sellerType = domainModel.sellerType
        self.yearOfManufacture = domainModel.firstRegistration?.dateInt
        self.bodyType = domainModel.bodyType
        self.shortDescription = ""
        self.images = domainModel.images
        self.condition = domainModel.condition
        self.transportModel = domainModel.model
        self.location = domainModel.location
        self.sellerName = domainModel.sellerName
    }
}
