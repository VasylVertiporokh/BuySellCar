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
    var images: AdvertisementImages?
    var adsRemoteImages: [AdvertisementImagesModel]?
    var location: String?
    var adsImages: [CollageImageModel]?
    var contactsInfo: ContactsInfo?
    
    // MARK: - Computed properties
    var needCreateImagesModel: Bool {
        return adsImages == nil
    }
    
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
        self.images = model.images
        self.location = model.location
        self.adsImages = model.adsImages?
            .map { .init(imageModel: $0) }
        
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

struct CollageImageModel {
    var collageImage: ImageResources
    var index: Int
    var photoRacurs: String
    
    // MARK: - Init
    init(imageModel: AdvertisementImagesModel) {
        self.collageImage = .formRemote(imageModel.imageUrl)
        self.index = imageModel.imageIndex
        self.photoRacurs = imageModel.photoRacurs
    }
    
    init(collageImage: ImageResources, index: Int, photoRacurs: String) {
        self.collageImage = collageImage
        self.index = index
        self.photoRacurs = photoRacurs
    }
}

struct AdsPhotoModel: Hashable {
    var photoRacurs: Racurs
    let imageIndex: Int
    var image: ImageResources
    
    // MARK: - Static properties
    static var photoModel: [Self] {
        [
            .init(photoRacurs: .frontLeftSide, imageIndex: 0, image: .fromAssets(Assets.frontLeftSizeIcon)),
            .init(photoRacurs: .backRightSide, imageIndex: 1, image: .fromAssets(Assets.backRightSideIcon)),
            .init(photoRacurs: .frontSide, imageIndex: 2, image: .fromAssets(Assets.frontSideIcon)),
            .init(photoRacurs: .backSide, imageIndex: 3, image: .fromAssets(Assets.backSideIcon)),
            .init(photoRacurs: .dashboard, imageIndex: 4, image: .fromAssets(Assets.dashboardIcon)),
            .init(photoRacurs: .interior, imageIndex: 5, image: .fromAssets(Assets.interiorIcon)),
            .init(photoRacurs: .bodySide, imageIndex: 6, image: .fromAssets(Assets.bodySideIcon))
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
        
        var racursPlaceholder: ImageAsset {
            switch self {
            case .frontLeftSide:            return Assets.frontLeftSizeIcon
            case .backRightSide:            return Assets.backRightSideIcon
            case .frontSide:                return Assets.frontSideIcon
            case .backSide:                 return Assets.backSideIcon
            case .dashboard:                return Assets.dashboardIcon
            case .interior:                 return Assets.interiorIcon
            case .bodySide:                 return Assets.bodySideIcon
            }
        }
    }
}
