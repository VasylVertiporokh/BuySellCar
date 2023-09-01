//
//  AdvertisementRecomendationViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.03.2023.
//

import UIKit

final class AdvertisementRecommendationViewController: BaseViewController<AdvertisementRecommendationViewModel> {
    // MARK: - Views
    private let contentView = AdvertisementRecommendationView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        contentView.showSkeleton()
    }
}

// MARK: - Private extension
private extension AdvertisementRecommendationViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .startSearch:              viewModel.startSearch()
                case .rowSelected(let row):     viewModel.showSelected(row)
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionsPublisher
            .dropFirst()
            .sink { [unowned self] in contentView.setupSnapshot(sections: $0) }
            .store(in: &cancellables)
        
        viewModel.eventsPublisher
            .sink { [unowned self] event in
                switch event {
                case .hideSkeleton:             contentView.hideSkeleton()
                }
            }
            .store(in: &cancellables)
    }
}
