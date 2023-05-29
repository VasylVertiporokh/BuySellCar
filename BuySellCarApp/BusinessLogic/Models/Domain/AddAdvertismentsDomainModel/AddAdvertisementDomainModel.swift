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
    var mainTechnicalInfo: TechnicalInfoModel?
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
}

struct FirstRegistrationDataModel {
    var dateString: String = Date().convertToString(format: .monthYear)
    var dateInt: Int = Date().convertToIntYear
}

struct TechnicalInfoModel {
    var price: Int?
    var millage: Int?
    var power: Int?
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
