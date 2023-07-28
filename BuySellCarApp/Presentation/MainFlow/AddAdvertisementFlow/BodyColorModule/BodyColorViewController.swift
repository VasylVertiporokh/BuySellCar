//
//  BodyColorViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import UIKit

final class BodyColorViewController: BaseViewController<BodyColorViewModel> {
    // MARK: - Views
    private let contentView = BodyColorView()
    
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
private extension BodyColorViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .cellDidTap(let colorRow):
                    viewModel.setSelectedBodyColor(row: colorRow)
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionsPublisher
            .sink { [unowned self] sections in
                contentView.setupSnapshot(sections: sections)
            }
            .store(in: &cancellables)
    }
    
    func setupNavigationBar() {
        title = "Body color"
    }
}
