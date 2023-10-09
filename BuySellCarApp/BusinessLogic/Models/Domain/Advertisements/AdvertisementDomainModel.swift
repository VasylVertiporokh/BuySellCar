//
//  AdvertisementDomainModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 07.04.2023.
//

import Foundation

struct AdvertisementDomainModel {
    let isDatabaseModel: Bool
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
    var images: AdvertisementImages?
    var adsImages: [AdvertisementImagesModel]?
    let sellerName: String
    let ownerinfo: OwnerInfoModel
    
    // MARK: - Computed properties
    var sellingType: SellerType {
        ownerinfo.isCommercialSales ? .diller : .owner
    }
    
    // MARK: - Init from response
    init(advertisementResponseModel: AdvertisementResponseModel) {
        isDatabaseModel = false
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
        adsImages = advertisementResponseModel.adsImages
        sellerName = advertisementResponseModel.sellerName
        ownerinfo = .init(model: advertisementResponseModel.userData)
    }
    
    // MARK: - Init from data base model
    init(dataBaseModel: AdsCoreDataModel) {
        isDatabaseModel = true
        bodyType = BodyType.init(rawString: dataBaseModel.bodyType)
        transportName = dataBaseModel.transportName
        bodyColor = CarColor.init(rawString: dataBaseModel.bodyColor)
        description = dataBaseModel.des
        avarageFuelConsumption = dataBaseModel.avarageFuelConsumption
        ownerID = dataBaseModel.ownerId
        interiorColor = CarColor.init(rawString: dataBaseModel.interiorColor)
        price = Int(dataBaseModel.price)
        transmissionType = TransmissionType.init(rawString: dataBaseModel.transmissionType)
        power = Int(dataBaseModel.power)
        objectID = dataBaseModel.objectId
        mileage = Int(dataBaseModel.mileage)
        doorCount = DoorCount(rawInt: Int(dataBaseModel.doorCount))
        yearOfManufacture = Int(dataBaseModel.yearOfManufacture)
        created = Int(dataBaseModel.created)
        transportModel = dataBaseModel.transportModel
        interiorFittings = dataBaseModel.interiorFittings
        photo = dataBaseModel.photo
        shortDescription = dataBaseModel.shortDes
        numberOfSeats = NumberOfSeats(rawInt: Int(dataBaseModel.numberOfSeats))
        condition = Condition.init(rawString: dataBaseModel.condition)
        fuelType = FuelType.init(rawString: dataBaseModel.fuelType)
        location = dataBaseModel.location
        sellerType = .init(rawString: dataBaseModel.sellerType)
        updated = Int(dataBaseModel.wasUpdated)
        images = .init(carImages: dataBaseModel.images)
        sellerName = dataBaseModel.sellerName
        ownerinfo = .init(model: dataBaseModel.ownerInfo)
    }
}

struct OwnerInfoModel {
    let withWhatsAppAccount: Bool
    let isCommercialSales: Bool
    let ownerId: String
    let phoneNumber: String
    let name: String
    let email: String
    
    // MARK: - Init from response model
    init(model: OwnerInfo) {
        self.withWhatsAppAccount = model.withWhatsAppAccount
        self.isCommercialSales = model.isCommercialSales
        self.ownerId = model.ownerId
        self.phoneNumber = model.phoneNumber
        self.name = model.name
        self.email = model.email
    }
    
    // MARK: - Init from data base model
    init(model: OwnerInfoCoreDataModel?) {
        // TODO: - Need fix
        self.withWhatsAppAccount = model!.withWhatsAppAccount
        self.isCommercialSales = model!.isCommercialSales
        self.ownerId = model!.ownerId
        self.phoneNumber = model!.phoneNumber
        self.name = model!.name
        self.email = model!.email
    }
}
