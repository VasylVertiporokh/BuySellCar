//
//  ShadowModifier.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 22/08/2023.
//

import SwiftUI

struct ShadowModifier: ViewModifier {
    // MARK: - Internal properties
    var color: Color = .white
    var shadowColor: Color = .gray
    var shadowRadius: CGFloat = 5
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
                    .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 2)
            )
    }
}
