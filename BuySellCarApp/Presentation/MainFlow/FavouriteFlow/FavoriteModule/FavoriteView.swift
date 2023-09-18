//
//  FavoriteView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 21/08/2023.
//

import SwiftUI

struct FavoriteView: View {
    // MARK: - View model
    @StateObject var viewModel: FavoriteViewModel
    
    // MARK: - Body
    var body: some View {
        VStack {
            switch viewModel.loadingState {
            case .loading:        loadingView
            case .loaded:         listView
            case .empty:          emptyStateView
            case .error:          errorView
            }
        }
        .onAppear {
            viewModel.onViewDidLoad()
        }
        .alert(item: $viewModel.alert, content: { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .cancel(Text(alert.buttonTitle), action: {
                    alert.action?()
                })
            )
        })
    }
}

// MARK: - Subview
private extension FavoriteView {
    var listView: some View {
        ScrollView {
            if !viewModel.isLoadingFinished {
                ProgressView()
                    .scaleEffect(Size.progressViewScale)
                    .padding([.top, .bottom], Size.progressViewPadding)
            }
            LazyVStack(spacing: Size.defaultSpacing) {
                ForEach($viewModel.favoriteModel, id: \.objectId) { item in
                    FavoriteCellView(item: item) { action in
                        switch action {
                        case .deleteItem(let id):    viewModel.deleteFromFavoritListBy(id: id)
                        case .cellDidTap(let id):    viewModel.showDetails(id: id)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - Size.defaultSpacing)
                }
            }
        }
        .animation(.default, value: viewModel.isLoadingFinished)
    }
    
    var loadingView: some View {
        LottieView(name: "favLoader")
            .frame(height: Size.stateViewHeight)
            .padding(.horizontal, Size.stateViewPadding)
    }
    
    var emptyStateView: some View {
        VStack {
            LottieView(name: "emptyState")
                .frame(height: Size.stateViewHeight)
            Text("You have no favorite ads.")
                .font(FontFamily.Montserrat.bold.swiftUIFont(fixedSize: 20))
        }
        .padding(.horizontal, Size.stateViewPadding)
    }
    
    var errorView: some View {
        VStack() {
            Text(Localization.defaultMessage)
                .font(FontFamily.Montserrat.semiBold.swiftUIFont(fixedSize: 18))
            LottieView(name: "errorState")
                .frame(height: Size.stateViewHeight)
                .padding(.horizontal, Size.stateViewPadding)
            buttonView
        }
        .padding(.horizontal, Size.horizontalPadding)
    }
    
    var buttonView: some View {
        VStack(spacing: Size.progressViewPadding) {
            Button(action: {
                viewModel.reloadData()
            }, label: {
                Text("Press to try again")
                    .font(FontFamily.Montserrat.regular.swiftUIFont(fixedSize: 16))
                    .foregroundColor(Colors.buttonDarkGray.swiftUIColor)
                    .frame(height: Size.defaultButtonHeight)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, Size.stateViewPadding)
                    .modifier(ShadowModifier(color: Colors.buttonYellow.swiftUIColor, shadowRadius: Size.shadowRadius))
            })
            Text("OR")
                .font(FontFamily.Montserrat.regular.swiftUIFont(fixedSize: 16))
                .foregroundColor(.gray)
            Button(action: {
                viewModel.loadFromDatabase()
            }, label: {
                Text("Use offline mode?")
                    .font(FontFamily.Montserrat.regular.swiftUIFont(fixedSize: 16))
                    .foregroundColor(Colors.buttonDarkGray.swiftUIColor)
                    .frame(height: Size.defaultButtonHeight)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, Size.stateViewPadding)
                    .modifier(ShadowModifier(color: Colors.buttonYellow.swiftUIColor, shadowRadius: Size.shadowRadius))
            })
        }
    }
}

// MARK: - SizeConstant
private enum Size {
    static let defaultSpacing: CGFloat = 16
    static let stateViewHeight: CGFloat = 150
    static let stateViewPadding: CGFloat = 64
    static let defaultButtonHeight: CGFloat = 44
    static let shadowRadius: CGFloat = 2
    static let horizontalPadding: CGFloat = 32
    static let progressViewScale: CGFloat = 1.5
    static let progressViewPadding: CGFloat = 8
}
