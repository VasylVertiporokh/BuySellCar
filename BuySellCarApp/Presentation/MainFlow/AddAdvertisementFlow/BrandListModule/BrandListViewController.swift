//
//  BrandListViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import UIKit

final class BrandListViewController: BaseViewController<BrandListViewModel> {
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
}

// MARK: - Private extension
private extension BrandListViewController {
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
            .sink { [unowned self] section in
                contentView.setupSnapshot(sections: section)
            }
            .store(in: &cancellables)
    }
    
    func setupNavigationBar() {
        title = "Make"
    }
}
