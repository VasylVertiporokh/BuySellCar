//
//  DoorCountView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/09/2023.
//

import SwiftUI

struct DoorCountView: View {
    // MARK: - View model
    @StateObject var viewModel: DoorCountViewModel

    // MARK: - Body
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach($viewModel.items, id: \.id) { item in
                    Divider()
                    CheckBoxCell(item: item) { model in
                        viewModel.setNumberOfDoors(model.itemCount)
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
