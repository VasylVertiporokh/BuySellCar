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
        contentView.configureWithSearchView()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .cellDidTap(let row):
                    print(row)
                }
            }
            .store(in: &cancellables)
        
        contentView.filterPublisher
            .sink(receiveValue: { [unowned self] action in
                switch action {
                case .cancelDidTapped:
                    self.dismiss(animated: true)
                case .doneDidTapped:
                    self.dismiss(animated: true)
                case .filterTextDidEntered(let filterText):
                    viewModel.filterByBrand(filterText)
                }
            })
            .store(in: &cancellables)
        
        viewModel.sectionsPublisher
            .sink { [unowned self] sections in contentView.setupSnapshot(sections: sections) }
            .store(in: &cancellables)
    }
}
