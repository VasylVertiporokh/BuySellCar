//
//  TrandingCategoriesResponseModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 25/07/2023.
//

import Foundation

struct TrandingCategoriesResponseModel: Decodable {
    let id: Int
    let categoryTitle: String
    let categoryImageURL: String
    let fuelType: [String]
    let bodyType: [String]
    let transmissionType: [String]
    let year: SelectedRange
    let power: SelectedRange
    let millage: SelectedRange
}

struct SelectedRange: Decodable {
    var minSelected: Double?
    var maxSelected: Double?
}
