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
