//
//  UserInfoViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 01.03.2023.
//

import UIKit

final class UserInfoViewController: BaseViewController<UserInfoViewModel> {
    // MARK: - Views
    private let contentView = UserInfoView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                    
                }
            }
            .store(in: &cancellables)
        
        viewModel.eventsPublisher
            .sink { [unowned self] events in
                switch events {
                case .showUserInfo(let userModel):
                    contentView.setUserInfo(model: userModel)
                }
            }
            .store(in: &cancellables)
    }
}
