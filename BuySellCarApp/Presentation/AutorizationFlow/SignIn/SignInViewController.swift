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
                case .nickNameDidEnter(let nick):            viewModel.setNickname(nick)
                case .passwordDidEnter(let password):        viewModel.setPassword(password)
                case .loginDidTap:                           viewModel.login()
                case .forgotPasswordDidTap:                  viewModel.showRestorePassword()
                case .createAccountDidTap:                   viewModel.showCreateAccount()
                }
            }
            .store(in: &cancellables)
        
        viewModel.validationPublisher
            .sink { [unowned self] in contentView.applyValidation(form: $0) }
            .store(in: &cancellables)
        
        keyboardHeightPublisher
            .sink { [unowned self] in contentView.setScrollViewOffSet(offSet: $0) }
            .store(in: &cancellables)
    }
}
