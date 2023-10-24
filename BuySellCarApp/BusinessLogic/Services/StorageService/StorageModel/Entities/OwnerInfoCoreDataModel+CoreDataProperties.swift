//
//  OwnerInfoCoreDataModel+CoreDataProperties.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 05/09/2023.
//
//

import Foundation
import CoreData


extension OwnerInfoCoreDataModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<OwnerInfoCoreDataModel> {
        return NSFetchRequest<OwnerInfoCoreDataModel>(entityName: "OwnerInfoCoreDataModel")
    }

    @NSManaged public var email: String
    @NSManaged public var isCommercialSales: Bool
    @NSManaged public var name: String
    @NSManaged public var ownerId: String
    @NSManaged public var phoneNumber: String
    @NSManaged public var withWhatsAppAccount: Bool

}

extension OwnerInfoCoreDataModel : Identifiable { }
