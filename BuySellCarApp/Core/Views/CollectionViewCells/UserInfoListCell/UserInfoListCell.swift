//
//  UserInfoListCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 14.03.2023.
//

import UIKit
import Kingfisher

class UserInfoListCell: UICollectionViewListCell {
    // MARK: - Internal properties
    var cellItem: UserProfileCellModel?
    
    // MARK: - Override methods
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = UserInfoCellContentConfiguration().updated(for: state)
        newConfiguration.userNickname = cellItem?.username
        newConfiguration.userAvatar = cellItem?.avatar
        newConfiguration.lastProfileUpdate = cellItem?.lastProfileUpdate
        contentConfiguration = newConfiguration
        isSelected = false
    }
}
