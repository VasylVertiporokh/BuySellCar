//
//  AdvertisementSearchResultDataSource.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.03.2023.
//

import Foundation

// MARK: - AdvertisementSearchResultSection
enum AdvertisementSearchResultSection: Int, CaseIterable {
    case searchResult
}

// MARK: - AdvertisementResultRow
enum AdvertisementResultRow: Hashable {
    case searchResultRow(model: AdvertisementCellModel)
}

// MARK: - Internal extension
extension AdvertisementResultRow {
    var carImages: [String] {
        switch self {
        case .searchResultRow(let model):
            return model.imageArray ?? [""]
        }
    }
}

// MARK: - CarImage Section
enum CarImageSection: Int, CaseIterable {
    case images
}

// MARK: - CarImage rows
enum CarImageRow: Hashable {
    case carImage(String)
}


// MARK: - Filtered sections
enum FilteredSection: Int, CaseIterable {
    case filtered
}

// MARK: - FilteredRow rows
enum FilteredRow: Hashable {
    case filteredParameter(SearchParam)
}
