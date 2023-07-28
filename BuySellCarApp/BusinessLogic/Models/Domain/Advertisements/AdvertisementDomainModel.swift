//
//  AdvertisementDomainModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 07.04.2023.
//

import Foundation

struct AdvertisementDomainModel {
    let bodyType: BodyType
    let transportName: String
    let bodyColor: CarColor
    let description: String?
    let avarageFuelConsumption: Double
    let ownerID: String?
    let interiorColor: CarColor
    let price: Int
    let transmissionType: TransmissionType
    let power: Int
    let objectID: String
    let mileage: Int
    let doorCount: Int
    let yearOfManufacture: Int
    let created: Int
    let transportModel: String
    let interiorFittings: String?
    let photo: String?
    let shortDescription: String?
    let numberOfSeats: Int
    let condition: Condition
    let fuelType: FuelType
    let location: String?
    let sellerType: SellerType
    let updated: Int?
    var images: AdvertisementImages?
    let sellerName: String
    
    // MARK: - Init
    init(advertisementResponseModel: AdvertisementResponseModel) {
        bodyType = advertisementResponseModel.bodyType
        transportName = advertisementResponseModel.transportName
        bodyColor = advertisementResponseModel.bodyColor
        description = advertisementResponseModel.description
        avarageFuelConsumption = advertisementResponseModel.avarageFuelConsumption
        ownerID = advertisementResponseModel.ownerID
        interiorColor = advertisementResponseModel.interiorColor
        price = advertisementResponseModel.price
        transmissionType = advertisementResponseModel.transmissionType
        power = advertisementResponseModel.power
        objectID = advertisementResponseModel.objectID
        mileage = advertisementResponseModel.mileage
        doorCount = advertisementResponseModel.doorCount
        yearOfManufacture = advertisementResponseModel.yearOfManufacture
        created = advertisementResponseModel.created
        transportModel = advertisementResponseModel.transportModel
        interiorFittings = advertisementResponseModel.interiorFittings
        photo = advertisementResponseModel.photo
        shortDescription = advertisementResponseModel.shortDescription
        numberOfSeats = advertisementResponseModel.numberOfSeats
        condition = advertisementResponseModel.condition
        fuelType = advertisementResponseModel.fuelType
        location = advertisementResponseModel.location
        sellerType = advertisementResponseModel.sellerType
        updated = advertisementResponseModel.updated
        images = advertisementResponseModel.images
        sellerName = advertisementResponseModel.sellerName
    }
}
