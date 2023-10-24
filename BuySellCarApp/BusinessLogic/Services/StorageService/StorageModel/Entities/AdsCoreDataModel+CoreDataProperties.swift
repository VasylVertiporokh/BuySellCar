//
//  AdsCoreDataModel+CoreDataProperties.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 05/09/2023.
//
//

import Foundation
import CoreData


extension AdsCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AdsCoreDataModel> {
        return NSFetchRequest<AdsCoreDataModel>(entityName: "AdsCoreDataModel")
    }
    
    @NSManaged public var isOwnAds: Bool
    @NSManaged public var avarageFuelConsumption: Double
    @NSManaged public var bodyColor: String
    @NSManaged public var bodyType: String
    @NSManaged public var condition: String
    @NSManaged public var created: Int64
    @NSManaged public var des: String?
    @NSManaged public var doorCount: Int64
    @NSManaged public var fuelType: String
    @NSManaged public var interiorColor: String
    @NSManaged public var interiorFittings: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var location: String?
    @NSManaged public var mileage: Int64
    @NSManaged public var numberOfSeats: Int64
    @NSManaged public var objectId: String
    @NSManaged public var ownerId: String?
    @NSManaged public var photo: String?
    @NSManaged public var power: Int64
    @NSManaged public var price: Int64
    @NSManaged public var sellerName: String
    @NSManaged public var sellerType: String
    @NSManaged public var shortDes: String?
    @NSManaged public var transmissionType: String
    @NSManaged public var transportModel: String
    @NSManaged public var transportName: String
    @NSManaged public var wasUpdated: Int64
    @NSManaged public var yearOfManufacture: Int64
    @NSManaged public var ownerInfo: OwnerInfoCoreDataModel?
    @NSManaged public var adsImages: NSSet?

}

extension AdsCoreDataModel : Identifiable { }
