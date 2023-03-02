//
//  RestorePasswordViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 27.02.2023.
//

import UIKit

final class RestorePasswordViewController: BaseViewController<RestorePasswordViewModel> {
    // MARK: - Views
    private let contentView = RestorePasswordView()
    
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
                case .passwordTextFieldDidEnter(let password):
                    viewModel.setUserEmail(password)
                case .restorePasswordButtonDidTap:
                    viewModel.restorePassword()
                case .close:
                    viewModel.closeRestore()
                }
            }
            .store(in: &cancellables)
        
        viewModel.eventsPublisher.sink { [unowned self] events in
            switch events {
            case .isEmailValid(let isFieldValid):
                contentView.configureToValidState(isFieldValid)
            }
        }
        .store(in: &cancellables)
    }
}
