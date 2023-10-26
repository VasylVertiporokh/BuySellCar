//
//  DetailsViewController.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 01/08/2023.
//

import UIKit
import GoogleMobileAds

final class DetailsViewController: BaseViewController<DetailsViewModel> {
    // MARK: - Views
    private let navigationView = NavigationTitleView()
    private let contentView = DetailsView()
    private let rightTabBarView = TabBarButtonView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        configureNavigationBar()
        contentView.showAds()
    }
    
    // MARK: - Deinit
    deinit {
        viewModel.finishFlow()
    }
}

// MARK: - Private extenison
private extension DetailsViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .imageRowSelected(let imageRow):  viewModel.showSelectedImage(imageRow: imageRow)
                case .socialNetworkButtonDidTap:       viewModel.openWhatsApp()
                case .makeCallDidTap:                  viewModel.makeCall()
                case .sendEmailDidTap:                 viewModel.openSendEmail()
                }
            }
            .store(in: &cancellables)
        
        rightTabBarView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .buttonDidTap:
                    viewModel.addToFavorite()
                    rightTabBarView.startLoadingAnimation()
                }
            }
            .store(in: &cancellables)
        
        viewModel.advertisementDomainModelPublisher
            .sink { [unowned self] model in
                guard let model = model else {
                    return
                }
                contentView.configure(model: .init(adsDomainModel: model))
                let adsName = "\(model.transportName) \(model.transportModel)"
                let price = "€ \(model.price).-"
                navigationView.configure(model: .init(title: adsName , subtitle: price))
            }
            .store(in: &cancellables)
        
        viewModel.eventPublisher
            .sink { [unowned self] action in
                switch action {
                case .isFavorite(let isFavorite):
                    rightTabBarView.setState(isSelected: isFavorite)
                case .loadingError:
                    rightTabBarView.stopLoadingAnimation()
                case .offlineMode:
                    rightTabBarView.setDisabledState()
                    contentView.setOfflineMode()
                case .onlineMode:
                    rightTabBarView.startLoadingAnimation()
                }
            }
            .store(in: &cancellables)
    }
    
    func configureNavigationBar() {
        navigationItem.titleView = navigationView
        navigationController?.navigationBar.tintColor = Colors.buttonDarkGray.color
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightTabBarView)
    }
}
