//
//  SignInViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import UIKit

final class SignInViewController: BaseViewController<SignInViewModel> {
    // MARK: - Views
    private let contentView = SignInView()
    
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
                case .nickNameDidEnter(let nick):
                    viewModel.setNickname(nick)
                case .passwordDidEnter(let password):
                    viewModel.setPassword(password)
                case .loginDidTap:
                    viewModel.login()
                case .forgotPasswordDidTap:
                    viewModel.showRestorePassword()
                case .createAccountDidTap:
                    viewModel.showCreateAccount()
                }
            }
            .store(in: &cancellables)
        
        viewModel.eventsPublisher
            .sink { [weak self] events in
                switch events {
                case.isFieldsValid(let isValid):
                    self?.contentView.isButtonEnabled(isValid)
                case .isNicknameValis(let isValid):
                    self?.contentView.setIsNicknameValid(isValid)
                case .isPasswordValid(let isPasswordValid):
                    self?.contentView.setIsPasswordValid(isPasswordValid)
                }
            }
            .store(in: &cancellables)
    }
}
