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
        setupNavigationBar()
    }
}

// MARK: - Private extension
private extension AdvertisementRecommendationViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .recommendedTapped(let index):
                    viewModel.showSelectedRecommendation(index)
                case .startSearch:
                    viewModel.startSearch()
                case .quickSearchTapped(let sectionIndex, let itemIndex):
                    viewModel.showQuickResult(sectionIndex, itemIndex)
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionsAction
            .sink { [unowned self] in contentView.setupSnapshot(sections: $0) }
            .store(in: &cancellables)
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.clear.cgColor]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.clipsToBounds = true
    }
}
