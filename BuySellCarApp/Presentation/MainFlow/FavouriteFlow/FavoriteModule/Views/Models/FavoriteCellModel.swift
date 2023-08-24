//
//  FavoriteCellModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 24/08/2023.
//

import Foundation

struct FavoriteCellModel: Hashable {
    private(set) var objectId: String
    var imageUrl: URL?
    let adsName: String
    let price: String
    let bodyType: String
    let fuelType: String
    let sellerName: String
    let millage: String
    let sellerType: String
    let created: String
    var offset: CGFloat = 0.0
    var isSwiped: Bool = false
    
    // MARK: - Init
    init(domainModel: AdvertisementDomainModel) {
        self.objectId = domainModel.objectID
        self.adsName = "\(domainModel.transportName) \(domainModel.transportModel)"
        self.price = "€ \(domainModel.price).-"
        self.bodyType = domainModel.bodyType.rawValue
        self.fuelType = domainModel.fuelType.rawValue
        self.sellerName = domainModel.sellerName
        self.millage = "\(domainModel.mileage)"
        self.sellerType = domainModel.sellerType.rawValue
        self.created = domainModel.created.toDateType(dateType: "MM/dd/yyyy")
        
        if let firstImage = domainModel.images?.carImages?.first {
            self.imageUrl = URL(string: firstImage)
        }
    }
}
