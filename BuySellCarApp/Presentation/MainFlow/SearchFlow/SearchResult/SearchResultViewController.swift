//
//  SearchResultViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.03.2023.
//

import UIKit
import SnapKit

final class SearchResultViewController: BaseViewController<SearchResultViewModel> {
    // MARK: - Views
    private let contentView = SearchResultView()
    private let navigationView = NavigationTitleView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        navigationItem.titleView = navigationView
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                }
            }
            .store(in: &cancellables)
        
        viewModel.eventsPublisher
            .sink { [unowned self] events in
                switch events {
                case .advertisementCount(let count):
                    navigationView.setResultCount(count)
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionPublisher
            .sink { [unowned self] in contentView.setupSnapshot(sections: $0) }
            .store(in: &cancellables)
    }
}
