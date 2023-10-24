//
//  VehicleConditionView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 02/10/2023.
//

import SwiftUI

struct VehicleConditionView: View {
    // MARK: - View model
    @StateObject var viewModel: VehicleConditionViewModel

    // MARK: - Body
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach($viewModel.items, id: \.id) { item in
                    Divider()
                    CheckBoxCell(item: item) { model in
                        viewModel.setCondition(model.descriprion)
                    }
                    Divider()
                }
            }
            .padding(.leading, 16)
        }
        .onAppear {
            viewModel.onViewDidLoad()
        }
    }
}
