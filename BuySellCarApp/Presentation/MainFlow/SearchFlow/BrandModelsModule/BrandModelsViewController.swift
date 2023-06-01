//
//  BrandModelsViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 30.05.2023.
//

import UIKit

final class BrandModelsViewController: BaseViewController<BrandModelsViewModel> {
    // MARK: - Views
    private let contentView = ModelListView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.configureWithSearchView()
        setupBindings()
    }
}

// MARK: - Private extension
private extension BrandModelsViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .cellDidTap(let carModelRow):
                    viewModel.setBrandModel(carModelRow)
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
                    viewModel.filterByInputedText(filterText)
                    print(filterText)
                }
            })
            .store(in: &cancellables)
        
        viewModel.sectionsPublisher
            .sink { [unowned self] sections in
                contentView.setupSnapshot(sections: sections)
            }
            .store(in: &cancellables)
    }
}
