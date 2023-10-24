//
//  AdsImages+CoreDataProperties.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 16/10/2023.
//
//

import Foundation
import CoreData


extension AdsImages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AdsImages> {
        return NSFetchRequest<AdsImages>(entityName: "AdsImages")
    }

    @NSManaged public var imageUrl: String
    @NSManaged public var imageIndex: Int64
    @NSManaged public var photoRacurs: String

}

extension AdsImages : Identifiable {

}
