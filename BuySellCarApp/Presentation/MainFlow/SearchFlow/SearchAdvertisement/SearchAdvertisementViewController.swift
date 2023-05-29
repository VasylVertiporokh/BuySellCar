//
//  SearchAdvertisementViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.04.2023.
//

import UIKit
import Combine

final class SearchAdvertisementViewController: BaseViewController<SearchAdvertisementViewModel> {
    // MARK: - Views
    private let contentView = SearchAdvertisementView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBindings()
    }
}

// MARK: - Setup bindings
private extension SearchAdvertisementViewController {
    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .rowSelected(let searchRow):
                    viewModel.didSelect(searchRow)
                case .showAllMakes:
                    viewModel.showAllMakes()
                case .deleteSelectedBrands(let searchRow):
                    guard case let .selectedBrandRow(selectedBrand) = searchRow else { return }
                    viewModel.deleteSelectedBrand(selectedBrand)
                case .showResults:
                    viewModel.showSearchResults()
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionsPublisher
            .sink { [unowned self]  in contentView.setupSnapshot(sections: $0) }
            .store(in: &cancellables)
        
        viewModel.eventsPublisher
            .sink { [unowned self] events in
                switch events {
                case .numberOfAdvertisements(let count):
                    contentView.setNumberOfResults(count)
                }
            }
            .store(in: &cancellables)
    }
    
    func setupNavigationBar() {        
        title = "Search"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "New search",
            style: .plain,
            target: self,
            action: #selector(newSearchAction)
        )
    }
}

// MARK: - Actions
private extension SearchAdvertisementViewController {
    @objc
    func newSearchAction() {
        viewModel.resetSearch()
    }
}
