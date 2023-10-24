//
//  NumberOfSeatsCell.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/09/2023.
//

import SwiftUI

struct CheckBoxCell: View {
    // MARK: - Item
    @Binding var item: Model
    
    // MARK: - Action
    var cellDidTap: (CheckBoxCell.Model) -> Void
    
    // MARK: - Body
    var body: some View {
        containerStackView
            .frame(height: 40)
            .background(Color.white)
            .onTapGesture {
                cellDidTap(item)
            }
    }
}

// MARK: - Model
extension CheckBoxCell {
    struct Model: Identifiable {
        private(set) var id = UUID().uuidString
        var isSelected: Bool = false
        let descriprion: String
        var itemCount: Int = 0
    }
}


// MARK: - Subviews
private extension CheckBoxCell {
    var containerStackView: some View {
        HStack {
            Text(item.descriprion)
            Spacer()
            if item.isSelected {
                Image(Assets.checkMark.name)
            }
        }
        .padding(.all, 8)
    }
}
