//
//  TrandingCategoriesDomainModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 25/07/2023.
//

import Foundation

struct TrandingCategoriesDomainModel {
    let id: Int
    let categoryTitle: String
    let categoryImageURL: String
    let fuelType: [String]
    let bodyType: [String]
    let transmissionType: [String]
    let year: SelectedRange
    let power: SelectedRange
    let millage: SelectedRange
    
    // MARK: - Init from TrandingCategoriesResponseModel
    init(trandingResponseModel: TrandingCategoriesResponseModel) {
        self.id = trandingResponseModel.id
        self.categoryTitle = trandingResponseModel.categoryTitle
        self.categoryImageURL = trandingResponseModel.categoryImageURL
        self.fuelType = trandingResponseModel.fuelType
        self.bodyType = trandingResponseModel.bodyType
        self.transmissionType = trandingResponseModel.transmissionType
        self.year = trandingResponseModel.year
        self.power = trandingResponseModel.power
        self.millage = trandingResponseModel.millage
    }
}
