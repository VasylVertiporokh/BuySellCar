//
//  FuelTypeListViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import UIKit

final class FuelTypeListViewController: BaseViewController<FuelTypeListViewModel> {
    // MARK: - Views
    private let contentView = FuelTypeListView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

// MARK: - Private extension
private extension FuelTypeListViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .cellDidTap(let row):
                    viewModel.setSelectedFuelType(row: row)
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionsPublisher
            .sink { [unowned self] sections in
                contentView.setupSnapshot(sections: sections)
            }
            .store(in: &cancellables)
    }
}
