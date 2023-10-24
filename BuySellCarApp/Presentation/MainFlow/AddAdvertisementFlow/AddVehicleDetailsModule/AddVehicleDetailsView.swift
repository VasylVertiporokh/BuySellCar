//
//  AddVehicleDetailsView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 23/09/2023.
//

import SwiftUI

struct AddVehicleDetailsView: View {
    // MARK: - View model
    @StateObject var viewModel: AddVehicleDetailsViewModel
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            Group {
                containerStackView
            }
            .padding()
        }
        .onAppear {
            viewModel.onViewDidLoad()
        }
    }
}

// MARK: - Subviews
private extension AddVehicleDetailsView {
    var containerStackView: some View {
        LazyVStack(spacing: 16) {
            ForEach($viewModel.detailsModel, id: \.dataType) { row in
                DetailsCellView(item: row) { type in
                    viewModel.showSelectedData(type: type)
                }
            }
        }
    }
}
