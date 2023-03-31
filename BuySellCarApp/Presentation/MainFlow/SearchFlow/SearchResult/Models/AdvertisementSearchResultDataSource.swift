//
//  AdvertisementSearchResultDataSource.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.03.2023.
//

import Foundation

// MARK: - Sections
enum AdvertisementSearchResultSection: Int, CaseIterable {
    case searchResult
}

// MARK: - Settings rows
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

// MARK: - Sections
enum CarImageSection: Int, CaseIterable {
    case images
}

// MARK: - Settings rows
enum CarImageRow: Hashable {
    case carImage(String)
}
