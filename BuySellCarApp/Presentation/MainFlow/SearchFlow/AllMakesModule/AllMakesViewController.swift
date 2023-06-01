//
//  AllMakesViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.05.2023.
//

import UIKit

final class AllMakesViewController: BaseViewController<AllMakesViewModel> {
    // MARK: - Views
    private let contentView = BrandListView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSearchBarBinding()
        navigationItem.hidesSearchBarWhenScrolling = true
    }
}

// MARK: - Private extension
private extension AllMakesViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .cellDidTap(let row):
                    viewModel.setSelectedBrand(item: row)
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionsPublisher
            .sink { [unowned self] sections in contentView.setupSnapshot(sections: sections) }
            .store(in: &cancellables)
    }
    
    func setupSearchBarBinding() {
        navigationItem.searchController?.searchBar.textDidChangePublisher
            .sink { [unowned self] in viewModel.filterByBrand($0) }
            .store(in: &cancellables)
        
        navigationItem.searchController?.searchBar.cancelButtonClickedPublisher
            .sink(receiveValue: { [unowned self] in
                viewModel.filterByBrand()
            })
            .store(in: &cancellables)
    }
    
    func setupNavigationBar() {
        title = "Make"
        navigationItem.searchController = UISearchController(searchResultsController: nil)
    }
}
