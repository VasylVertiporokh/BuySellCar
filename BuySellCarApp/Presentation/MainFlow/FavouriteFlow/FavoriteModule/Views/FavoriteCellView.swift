//
//  CellView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 22/08/2023.
//

import SwiftUI
import Kingfisher

enum FavoriteCellViewAction {
    case deleteItem(String)
    case cellDidTap(String)
}

struct FavoriteCellView: View {
    // MARK: - Cell model
    @Binding var item: FavoriteCellModel
    
    // MARK: - Private properties
    @State private var isMove = false
    
    // MARK: - Action
    var action: (FavoriteCellViewAction) -> Void
    
    // MARK: - Body
    var body: some View {
        ZStack {
            if isMove {
                deleteItemView
            }
            containerStackView
                .modifier(ShadowModifier())
                .offset(x: item.offset)
                .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
                .onTapGesture {
                    action(.cellDidTap(item.objectId))
                }
        }
    }
}

// MARK: - Subviews
private extension FavoriteCellView {
    var containerStackView: some View {
        VStack(spacing: 12) {
            mainInfoStackView
            infoContainer
        }
    }
    
    var deleteItemView: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [Color.red, Color.yellow]), startPoint: .leading, endPoint: .trailing)
                .cornerRadius(10)
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.easeIn) {
                        action(.deleteItem(item.objectId))
                    }
                }) {
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 90, height: 50)
                }
            }
        }
    }
    
    var mainInfoStackView: some View {
        HStack(spacing: 8) {
            KFImage(item.imageUrl)
                .resizable()
                .frame(width: 135, height: 90)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(item.adsName)
                    .font(FontFamily.Montserrat.semiBold.swiftUIFont(fixedSize: 18))
                Text(item.bodyType)
                Spacer()
                    .frame(height: 16)
                Text(item.price)
                    .font(FontFamily.Montserrat.semiBold.swiftUIFont(fixedSize: 16))
            }
            .font(FontFamily.Montserrat.regular.swiftUIFont(fixedSize: 16))
            Spacer()
        }
        .padding([.top, .leading], 12)
    }
    
    var infoContainer: some View {
        VStack(spacing: 8) {
            horisontalContainerStackView
        }
    }
    
    var horisontalContainerStackView: some View {
        HStack {
            leftTitleStackView
            Spacer()
            rightLabelStackView
            Spacer()
        }
        .padding([.horizontal, .bottom])
    }
    
    var leftTitleStackView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Seller name:")
            Text("Fuel type:")
            Text("Seller type:")
            Text("Created:")
        }
        .font(FontFamily.Montserrat.semiBold.swiftUIFont(fixedSize: 12))
    }
    
    var rightLabelStackView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(item.sellerName)
            Text(item.fuelType)
            Text(item.sellerType)
            Text(item.created)
        }
        .font(FontFamily.Montserrat.regular.swiftUIFont(fixedSize: 12))
    }
}

// MARK: - Private extenison
private extension  FavoriteCellView {
    func onChanged(value: DragGesture.Value) {
        isMove = true
        if value.translation.width < 0 {
            if item.isSwiped {
                item.offset = value.translation.width - 90
            } else {
                item.offset = value.translation.width
            }
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeInOut(duration: 0.3)) {
            if value.translation.width < 0 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    item.offset = -1000
                    action(.deleteItem(item.objectId))
                } else if -item.offset > 50 {
                    item.isSwiped = true
                    item.offset = -90
                } else {
                    item.isSwiped = false
                    isMove = false
                    item.offset = .zero
                }
            } else {
                item.isSwiped = false
                item.offset = .zero
            }
        }
    }
}
