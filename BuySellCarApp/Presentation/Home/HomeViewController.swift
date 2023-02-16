//
//  HomeViewController.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 20.11.2021.
//

import UIKit

final class HomeViewController: BaseViewController<HomeViewModel> {
    // MARK: - Views
    private let contentView = HomeView()

    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        title = Localization.home.uppercased()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .didSelect(let dog):
                    viewModel.showDetail(for: dog)
                    
                case .searchTextChanged(let text):
                    print(text)
                }
            }
            .store(in: &cancellables)
    }
}
