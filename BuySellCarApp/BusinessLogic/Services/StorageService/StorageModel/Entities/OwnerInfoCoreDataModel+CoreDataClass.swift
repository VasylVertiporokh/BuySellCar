//
//  OwnerInfoCoreDataModel+CoreDataClass.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 05/09/2023.
//
//


import Foundation
import CoreData

@objc(OwnerInfoCoreDataModel)
public class OwnerInfoCoreDataModel: NSManagedObject {
    
    // MARK: - Init from model
    convenience init(
        userInfoModel: OwnerInfoModel,
        insertIntoManagedObjectContext context: NSManagedObjectContext
    ) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: "OwnerInfoCoreDataModel",
            in: context
        ) else {
            fatalError("Erorr")
        }
        
        self.init(entity: entity, insertInto: context)
        withWhatsAppAccount = userInfoModel.withWhatsAppAccount
        isCommercialSales = userInfoModel.isCommercialSales
        ownerId = userInfoModel.ownerId
        phoneNumber = userInfoModel.phoneNumber
        name = userInfoModel.name
        email = userInfoModel.email
    }
}
