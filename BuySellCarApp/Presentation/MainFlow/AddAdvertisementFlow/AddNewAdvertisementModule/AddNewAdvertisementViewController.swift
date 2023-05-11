//
//  AddNewAdvertisementViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 11.05.2023.
//

import UIKit

final class AddNewAdvertisementViewController: BaseViewController<AddNewAdvertisementViewModel> {
    // MARK: - Views
    private let contentView = AddNewAdvertisementView()
    
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
private extension AddNewAdvertisementViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                }
            }
            .store(in: &cancellables)
    }
    
    func setupNavigationBar() {
        title = Localization.selling
    }
}
