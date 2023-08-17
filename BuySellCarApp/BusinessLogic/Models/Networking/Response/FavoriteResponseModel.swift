//
//  FavoriteResponseModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 17/08/2023.
//

import Foundation

struct FavoriteResponseModel: Decodable {
    let favorite: [AdvertisementResponseModel]
}
