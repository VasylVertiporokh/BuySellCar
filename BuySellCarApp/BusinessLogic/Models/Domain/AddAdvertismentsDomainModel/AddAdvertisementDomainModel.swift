//
//  AddAdvertisementDomainModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 25.05.2023.
//

import Foundation

// MARK: - AddAdvertisementDomainModel
struct AddAdvertisementDomainModel {
    var make: String?
    var model: String?
    var ownerId: String?
    var sellerName: String?
    var doorCount: Int = 5
    var numberOfSeats: Int = 5
    var mainTechnicalInfo = TechnicalInfoModel()
    var firstRegistration: FirstRegistrationDataModel?
    var fuelType: FuelType?
    var bodyColor: CarColor?
    var condition: Condition = .used
    var bodyType: BodyType = .sedan
    var sellerType: SellerType = .owner
    var transmissionType: TransmissionType = .manual
    var adsPhotoModel: [AdsPhotoModel] = AdsPhotoModel.photoModel
    var images: AdvertisementImages?
    var location: String?
    var contactsInfo: ContactsInfo?
    
    // MARK: - Empty init
    init() {}
    
    // MARK: - Init from ads domain model
    init(model: AdvertisementDomainModel) {
        self.make = model.transportName
        self.model = model.transportModel
        self.ownerId = model.ownerID
        self.sellerName = model.sellerName
        self.doorCount = model.doorCount.rawValue
        self.numberOfSeats = model.numberOfSeats.rawValue
        self.fuelType = model.fuelType
        self.bodyColor = model.bodyColor
        self.condition = model.condition
        self.bodyType = model.bodyType
        self.sellerType = model.sellerType
        self.transmissionType = model.transmissionType
        self.adsPhotoModel = AdsPhotoModel.photoModel
        self.images = model.images
        self.location = model.location
        
        self.contactsInfo = .init(
            email: model.ownerinfo.email,
            phoneNumber: model.ownerinfo.phoneNumber
        )
        
        self.mainTechnicalInfo = .init(
            price: model.price,
            millage: model.mileage,
            power: model.power
        )
        
        self.firstRegistration = .init(
            dateString: "\(model.yearOfManufacture)",
            dateInt: model.yearOfManufacture
        )
    }
}

struct FirstRegistrationDataModel {
    var dateString: String = Date().convertToString(format: .monthYear)
    var dateInt: Int = Date().convertToIntYear
}

struct TechnicalInfoModel {
    var price: Int?
    var millage: Int?
    var power: Int?
    
    var isInfoValid: Bool {
        price.isNilOrZero || millage.isNilOrZero || power.isNilOrZero
    }
}

struct AdsPhotoModel: Hashable {
    var photoRacurs: Racurs
    var selectedImage: Data?
    
    // MARK: - Computed properties
    var placeholderImageRow: Data? {
        return photoRacurs.racursPlaceholder
    }
    
    var withSelectedImage: Bool {
        return selectedImage != nil
    }
    
    // MARK: - Static properties
    static var photoModel: [Self] {
        [
            .init(photoRacurs: .frontLeftSide),
            .init(photoRacurs: .backRightSide),
            .init(photoRacurs: .frontSide),
            .init(photoRacurs: .backSide),
            .init(photoRacurs: .dashboard),
            .init(photoRacurs: .interior),
            .init(photoRacurs: .bodySide)
        ]
    }
    
    // MARK: - Photo racurs
    enum Racurs: String {
        case frontLeftSide = "frontLeftSide"
        case backRightSide = "backRightSide"
        case frontSide = "frontSide"
        case backSide = "backSide"
        case dashboard = "dashboard"
        case interior = "interior"
        case bodySide = "bodySide"
        
        var racursPlaceholder: Data? {
            switch self {
            case .frontLeftSide:            return Assets.frontLeftSizeIcon.image.pngData()
            case .backRightSide:            return Assets.backRightSideIcon.image.pngData()
            case .frontSide:                return Assets.frontSideIcon.image.pngData()
            case .backSide:                 return Assets.backSideIcon.image.pngData()
            case .dashboard:                return Assets.dashboardIcon.image.pngData()
            case .interior:                 return Assets.interiorIcon.image.pngData()
            case .bodySide:                 return Assets.bodySideIcon.image.pngData()
            }
        }
    }
}
