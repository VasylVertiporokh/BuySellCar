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
    private(set) var id = UUID().uuidString
    var placeholderImageRow: Data?
    var selectedImage: Data?
    var withSelectedImage: Bool {
        return selectedImage != nil
    }
    
    static var photoModel: [Self] {
        [
            .init(placeholderImageRow: Assets.frontLeftSizeIcon.image.pngData()),
            .init(placeholderImageRow: Assets.backRightSideIcon.image.pngData()),
            .init(placeholderImageRow: Assets.frontSideIcon.image.pngData()),
            .init(placeholderImageRow: Assets.backSideIcon.image.pngData()),
            .init(placeholderImageRow: Assets.dashboardIcon.image.pngData()),
            .init(placeholderImageRow: Assets.interiorIcon.image.pngData()),
            .init(placeholderImageRow: Assets.bodySideIcon.image.pngData())
        ]
    }
}
