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
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        configureNavigationBar()
        contentView.showAds(self)
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
    }
    
    func configureNavigationBar() {
        navigationItem.titleView = navigationView
        navigationController?.navigationBar.tintColor = Colors.buttonDarkGray.color
    }
}
