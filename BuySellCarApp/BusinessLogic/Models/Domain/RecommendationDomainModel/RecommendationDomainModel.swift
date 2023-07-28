//
//  RecommendationDomainModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 25/07/2023.
//

import Foundation

struct RecommendationDomainModel {
    let recommendationAds: [AdvertisementDomainModel]
    let trendingCategories: [TrandingCategoriesDomainModel]
    
    // MARK: - Init
    init(recommendationAds: [AdvertisementDomainModel] = [], trendingCategories: [TrandingCategoriesDomainModel] = []) {
        self.recommendationAds = recommendationAds
        self.trendingCategories = trendingCategories
    }
}
