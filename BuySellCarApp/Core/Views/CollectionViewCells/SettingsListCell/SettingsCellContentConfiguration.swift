//
//  SettingsCellContentConfiguration.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 14.03.2023.
//

import UIKit

struct SettingsCellContentConfiguration: UIContentConfiguration, Hashable {
    var cellTitleLabel: String?
    
    func makeContentView() -> UIView & UIContentView {
        return SettingsCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
