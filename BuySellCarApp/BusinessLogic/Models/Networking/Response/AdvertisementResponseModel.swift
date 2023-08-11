//
//  AdvertisementResponseModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.03.2023.
//

import Foundation
import UIKit

struct AdvertisementResponseModel: Decodable {
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
    let sellerName: String
    var images: AdvertisementImages?
    let userData: OwnerInfo

    enum CodingKeys: String, CodingKey {
        case bodyType, transportName, bodyColor, description, avarageFuelConsumption
        case ownerID = "ownerId"
        case interiorColor, price
        case transmissionType, power
        case objectID = "objectId"
        case mileage, doorCount, yearOfManufacture, created,
             transportModel, interiorFittings, photo,
             shortDescription, numberOfSeats, condition,
             fuelType, location, sellerType, updated,
             images, sellerName, userData
    }
}

struct AdvertisementImages: Codable {
    var carImages: [String]?
}

struct ContactsInfo: Codable {
    let email: String
    let phoneNumber: String
}

struct OwnerInfo: Decodable {
    let withWhatsAppAccount: Bool
    let isCommercialSales: Bool
    let ownerId: String
    let phoneNumber: String
    let name: String
    let email: String
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

enum Condition: String, Codable {
    case new = "New"
    case used = "Used"
}

enum FuelType: String, Codable, CaseIterable {
    case disel = "Disel"
    case electro = "Electro"
    case petrol = "Petrol"
    case hybrid = "Hybrid"
    case ethanol = "Ethanol"
    case hydrogen = "Hydrogen"
    case lpg = "LPG"
    case other = "Other"
}

enum CarColor: String, Codable, CaseIterable {
    case black = "Black"
    case gray = "Gray"
    case white = "White"
    case red = "Red"
    case blue = "Blue"
    case yellow = "Yellow"
    case orange = "Orange"
    case green = "Green"
    case brown = "Brown"
    case silver = "Silver"
    
    var colors: UIColor {
        switch self {
        case .black:     return .black
        case .gray:      return .gray
        case .white:     return .white
        case .red:       return .red
        case .blue:      return .blue
        case .yellow:    return .yellow
        case .orange:    return .orange
        case .green:     return .green
        case .brown:     return .brown
        case .silver:    return .lightGray
        }
    }
}

enum SellerType: String, Codable {
    case diller = "Diller"
    case owner = "Owner"
}

enum TransmissionType: String, Codable {
    case automatic = "Automatic"
    case manual = "Manual"
    case semiAutomatic = "Semi-automatic"
}
