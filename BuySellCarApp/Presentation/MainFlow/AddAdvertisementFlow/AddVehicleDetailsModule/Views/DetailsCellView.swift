//
//  DetailsCellView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 27/09/2023.
//

import SwiftUI

struct DetailsCellView: View {
    // MARK: - Item
    @Binding private(set) var item: VehicleDataCellModel
    
    // MARK: - Action
    var action: (VehicleDataType) -> Void
    
    // MARK: - Body
    var body: some View {
        HStack {
            containerStackView
        }
        .modifier(ShadowModifier())
        .onTapGesture {
            action(item.dataType)
        }
    }
}

// MARK: - Subviews
private extension DetailsCellView {
    var containerStackView: some View {
        HStack {
            Text(item.dataType.rawValue)
                .font(FontFamily.Montserrat.semiBold.swiftUIFont(size: 16))
            Spacer()
            descriptionStackView
        }
        .padding()
    }
    
    var descriptionStackView: some View {
        HStack(spacing: 16) {
            Text(item.dataDescriptionTitle ?? "")
                .font(FontFamily.Montserrat.regular.swiftUIFont(size: 16))
            Image(Assets.arrow.name)
                .resizable()
                .frame(width: 8, height: 16)
        }
    }
}
