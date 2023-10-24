//
//  AdsImages+CoreDataClass.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 16/10/2023.
//
//

import Foundation
import CoreData

@objc(AdsImages)
public class AdsImages: NSManagedObject {

    // MARK: - Init from model
    convenience init(
        imageModel: AdvertisementImagesModel,
        insertIntoManagedObjectContext context: NSManagedObjectContext
    ) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: "AdsImages",
            in: context
        ) else {
            fatalError("Erorr")
        }
        
        self.init(entity: entity, insertInto: context)
        self.imageUrl = imageModel.imageUrl
        self.photoRacurs = imageModel.photoRacurs
        self.imageIndex = Int64(imageModel.imageIndex)
    }
}
