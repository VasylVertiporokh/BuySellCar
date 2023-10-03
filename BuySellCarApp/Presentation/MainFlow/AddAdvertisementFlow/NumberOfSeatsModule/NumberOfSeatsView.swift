//
//  NumberOfSeatsView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 27/09/2023.
//

import SwiftUI

struct NumberOfSeatsView: View {
    // MARK: - View model
    @StateObject var viewModel: NumberOfSeatsViewModel
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach($viewModel.items, id: \.id) { item in
                    Divider()
                    CheckBoxCell(item: item) { model in
                        viewModel.setNumberOfSeats(model.itemCount)
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
