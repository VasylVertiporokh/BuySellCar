//
//  RecommendationDataSource.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.03.2023.
//

import Foundation
import UIKit

struct TrendingCategoriesModel: Hashable {
    let categoriesImage: UIImage
    let categoriesName: String
    let searchParameters: [SearchParam]
}

// MARK: - Sections
enum AdvertisementSection: Int, CaseIterable {
    case trendingCategories
    case recommended
    
    var headerTitle: String {
        switch self {
        case .recommended:
            return "We think you might also like:"
        case .trendingCategories:
            return "Trending categories:"
        }
    }
}

// MARK: - Settings rows
enum AdvertisementRow: Hashable {
    case recommended(model: AdvertisementCellModel)
    case trending(model: TrendingCategoriesModel)
}
