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
    let doorCount: DoorCount
    let yearOfManufacture: Int
    let created: Int
    let transportModel: String
    let interiorFittings: String?
    let photo: String?
    let shortDescription: String?
    let numberOfSeats: NumberOfSeats
    let condition: Condition
    let fuelType: FuelType
    let location: String?
    let sellerType: SellerType
    let updated: Int?
    let sellerName: String
    let images: AdvertisementImages?
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

enum DoorCount: Int, CaseIterable, Codable {
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    
    var description: String {
        return "\(self.rawValue)"
    }
    
    init(rawInt: Int) {
        switch rawInt {
        case 2:                 self = .two
        case 3:                 self = .three
        case 4:                 self = .four
        case 5:                 self = .five
        case 6:                 self = .six
        default:                self = .five
        }
    }
}

enum NumberOfSeats: Int, CaseIterable, Codable {
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case ten = 10
    
    var description: String {
        return "\(self.rawValue)".capitalized
    }
    
    init(rawInt: Int) {
        switch rawInt {
        case 2:                 self = .two
        case 3:                 self = .three
        case 4:                 self = .four
        case 5:                 self = .five
        case 6:                 self = .six
        default:                self = .ten
        }
    }
}

enum BodyType: String, CaseIterable, Codable {
    case hatchback = "Hatchback"
    case sedan = "Sedan"
    case suv = "SUV"
    case compact = "Compact"
    case stationWagon = "Station wagon"
    case cabrio = "Cabrio"
    case van = "Van"
    case transporter = "Transporter"
    
    init(rawString: String) {
        switch rawString {
        case "Hatchback":           self = .hatchback
        case "Sedan":               self = .sedan
        case "SUV":                 self = .suv
        case "Compact":             self = .compact
        case "Station wagon":       self = .stationWagon
        case "Cabrio":              self = .cabrio
        case "Van":                 self = .van
        case "Transporter":         self = .transporter
        default:                    self = .sedan
        }
    }
}

enum Condition: String, CaseIterable, Codable {
    case new = "New"
    case used = "Used"
    
    init(rawString: String) {
        switch rawString {
        case "New":                 self = .new
        case "Used":                self = .used
        default:                    self = .used
        }
    }
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
    
    init(rawString: String) {
        switch rawString {
        case "Disel":               self = .disel
        case "Electro":             self = .electro
        case "Petrol":              self = .petrol
        case "Hybrid":              self = .hybrid
        case "Ethanol":             self = .ethanol
        case "Hydrogen":            self = .hydrogen
        case "LPG":                 self = .lpg
        default:                    self = .other
        }
    }
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
        case .black:                return .black
        case .gray:                 return .gray
        case .white:                return .white
        case .red:                  return .red
        case .blue:                 return .blue
        case .yellow:               return .yellow
        case .orange:               return .orange
        case .green:                return .green
        case .brown:                return .brown
        case .silver:               return .lightGray
        }
    }
    
    init(rawString: String) {
        switch rawString {
        case "Black":               self = .black
        case "Gray":                self = .gray
        case "White":               self = .white
        case "Red":                 self = .red
        case "Blue":                self = .blue
        case "Yellow":              self = .yellow
        case "Orange":              self = .orange
        case "Green":               self = .green
        case "Brown":               self = .brown
        case "Silver":              self = .silver
        default:                    self = .white
        }
    }
}

enum SellerType: String, Codable {
    case diller = "Diller"
    case owner = "Owner"
    
    init(rawString: String) {
        switch rawString {
        case "Diller" :               self = .diller
        default:                     self = .owner
        }
    }
}

enum TransmissionType: String, Codable {
    case automatic = "Automatic"
    case manual = "Manual"
    case semiAutomatic = "Semi-automatic"
    
    init(rawString: String) {
        switch rawString {
        case "Automatic":            self = .automatic
        case "Manual":               self = .manual
        case "Semi-automatic":       self = .semiAutomatic
        default:                     self = .manual
        }
    }
}
