//
//  AdvertisementResponseModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.03.2023.
//

import Foundation

struct AdvertisementResponseModel: Codable {
    let bodyType: BodyType
    let transportName, bodyColor: String
    let description: String?
    let avarageFuelConsumption: Double
    let ownerID: String?
    let interiorColor: InteriorColor
    let price: Int
    let transmissionType: TransmissionType
    let power: Int
    let objectID: String
    let mileage: Int
    let doorCount: Int
    let yearOfManufacture: Int
    let created: Int
    let transportModel: String
    let interiorFittings, photo, shortDescription: String?
    let numberOfSeats: Int
    let condition: Condition
    let fuelType: FuelType
    let location: String?
    let sellerType: SellerType
    let updated: Int?

    enum CodingKeys: String, CodingKey {
        case bodyType, transportName, bodyColor, description, avarageFuelConsumption
        case ownerID = "ownerId"
        case interiorColor, price
        case transmissionType, power
        case objectID = "objectId"
        case mileage, doorCount, yearOfManufacture, created, transportModel, interiorFittings, photo, shortDescription, numberOfSeats, condition, fuelType, location, sellerType, updated
    }
}

enum BodyType: String, Codable {
    case hatchback = "Hatchback"
    case sedan = "Sedan"
    case suv = "SUV"
}

enum Condition: String, Codable {
    case new = "New"
    case used = "Used"
}

enum FuelType: String, Codable {
    case disel = "Disel"
    case electro = "Electro"
    case petrol = "Petrol"
    case hybrid = "Hybrid"
}

enum InteriorColor: String, Codable {
    case black = "Black"
    case gray = "Gray"
    case white = "White"
}

enum SellerType: String, Codable {
    case diller = "Diller"
    case owner = "Owner"
}

enum TransmissionType: String, Codable {
    case automatic = "Automatic"
    case manual = "Manual"
}

