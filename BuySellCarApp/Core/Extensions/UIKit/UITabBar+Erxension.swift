//
//  UITabBar+Erxension.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/08/2023.
//

import UIKit

extension UITabBar {
    func bageViewHorisontalPosition(_ position: CGFloat) {
        let itemAppearance = UITabBarItemAppearance()
        let appearance = UITabBarAppearance()
        itemAppearance.normal.badgePositionAdjustment.horizontal = position
        itemAppearance.normal.badgeBackgroundColor = Colors.buttonDarkGray.color
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        self.standardAppearance = appearance
    }
}
