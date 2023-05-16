//
//  AdvertisementResponseModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.03.2023.
//

import Foundation

struct AdvertisementResponseModel: Decodable {
    let bodyType: BodyType
    let transportName: String
    let bodyColor: String
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

    enum CodingKeys: String, CodingKey {
        case bodyType, transportName, bodyColor, description, avarageFuelConsumption
        case ownerID = "ownerId"
        case interiorColor, price
        case transmissionType, power
        case objectID = "objectId"
        case mileage, doorCount, yearOfManufacture, created, transportModel, interiorFittings, photo,
             shortDescription, numberOfSeats, condition, fuelType, location, sellerType, updated, images
    }
}

struct AdvertisementImages: Decodable {
    var objectId: String?
    var carImages: [String]?
}

enum BodyType: String, Codable {
    case hatchback = "Hatchback"
    case sedan = "Sedan"
    case suv = "SUV"
    case compact = "Compact"
    case stationWagon = "Station wagon"
    case cabrio = "Cabrio"
    case van = "Van"
    case transporter = "Transporter"
}

enum Condition: String, Decodable {
    case new = "New"
    case used = "Used"
}

enum FuelType: String, Decodable {
    case disel = "Disel"
    case electro = "Electro"
    case petrol = "Petrol"
    case hybrid = "Hybrid"
    case ethanol = "Ethanol"
    case hydrogen = "Hydrogen"
    case lpg = "LPG"
    case other = "Other"
}

enum InteriorColor: String, Decodable {
    case black = "Black"
    case gray = "Gray"
    case white = "White"
    case red = "Red"
    case blue = "Blue"
}

enum SellerType: String, Decodable {
    case diller = "Diller"
    case owner = "Owner"
}

enum TransmissionType: String, Decodable {
    case automatic = "Automatic"
    case manual = "Manual"
    case semiAutomatic = "Semi-automatic"
}
