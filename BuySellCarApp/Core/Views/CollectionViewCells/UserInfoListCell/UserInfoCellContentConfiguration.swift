//
//  UserInfoCellContentConfiguration.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 14.03.2023.
//

import UIKit

struct UserInfoCellContentConfiguration: UIContentConfiguration, Hashable {
    var lastProfileUpdate: Int?
    var userNickname: String?
    var userAvatar: URL?
    
    func makeContentView() -> UIView & UIContentView {
        return UserInfoCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
