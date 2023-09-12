//
//  FavoriteCoreDataModel+CoreDataClass.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 05/09/2023.
//
//

import Foundation
import CoreData

@objc(FavoriteCoreDataModel)
public class FavoriteCoreDataModel: NSManagedObject {
    
    // MARK: - Init from model
    convenience init(
        adsDomainModel: AdvertisementDomainModel,
        isFavorite: Bool = false,
        insertIntoManagedObjectContext context: NSManagedObjectContext) {
            
        guard let entity = NSEntityDescription.entity(
            forEntityName: "FavoriteCoreDataModel",
            in: context
        ) else {
            fatalError("Erorr")
        }
        
        self.init(entity: entity, insertInto: context)
        self.bodyType = adsDomainModel.bodyType.rawValue
        self.transportName = adsDomainModel.transportName
        self.bodyColor = adsDomainModel.bodyType.rawValue
        self.des = adsDomainModel.description
        self.avarageFuelConsumption = adsDomainModel.avarageFuelConsumption
        self.ownerId = adsDomainModel.ownerID
        self.interiorColor = adsDomainModel.interiorColor.rawValue
        self.price = Int64(adsDomainModel.price)
        self.transmissionType = adsDomainModel.transmissionType.rawValue
        self.power = Int64(adsDomainModel.power)
        self.objectId = adsDomainModel.objectID
        self.mileage = Int64(adsDomainModel.mileage)
        self.doorCount = Int64(adsDomainModel.doorCount)
        self.yearOfManufacture = Int64(adsDomainModel.yearOfManufacture)
        self.created = Int64(adsDomainModel.created)
        self.transportModel = adsDomainModel.transportModel
        self.interiorFittings = adsDomainModel.interiorFittings
        self.photo = adsDomainModel.photo
        self.shortDes = adsDomainModel.shortDescription
        self.numberOfSeats = Int64(adsDomainModel.numberOfSeats)
        self.condition = adsDomainModel.condition.rawValue
        self.fuelType = adsDomainModel.fuelType.rawValue
        self.location = adsDomainModel.location
        self.sellerType = adsDomainModel.sellerName
        self.wasUpdated = Int64(adsDomainModel.updated ?? .zero)
        self.images = adsDomainModel.images?.carImages
        self.sellerName = adsDomainModel.sellerName
        self.isFavorite = isFavorite
        self.ownerInfo = .init(
            userInfoModel: adsDomainModel.ownerinfo,
            insertIntoManagedObjectContext: context
        )
    }
}
