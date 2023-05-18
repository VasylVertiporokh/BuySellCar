//
//  ModelListViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 17.05.2023.
//

import UIKit

final class ModelListViewController: BaseViewController<ModelListViewModel> {
    // MARK: - Views
    private let contentView = ModelListView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

// MARK: - Private extension
private extension ModelListViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .cellDidTap(let model):
                    viewModel.setSelectedModel(row: model)
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionsPublisher
            .sink { [unowned self] section in
                contentView.setupSnapshot(sections: section)
            }
            .store(in: &cancellables)
    }
}
