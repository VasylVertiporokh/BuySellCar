//
//  SettingsListCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 14.03.2023.
//

import UIKit

class SettingsListCell: UICollectionViewListCell {    
    // MARK: - Internal properties
    var title: String?
    
    // MARK: - Override methods
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = SettingsCellContentConfiguration().updated(for: state)
        newConfiguration.cellTitleLabel = title
        contentConfiguration = newConfiguration
        isSelected = false
    }
}
