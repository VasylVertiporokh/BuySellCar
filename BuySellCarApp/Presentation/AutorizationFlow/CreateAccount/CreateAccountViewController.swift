//
//  CreateAccountViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.02.2023.
//

import UIKit

final class CreateAccountViewController: BaseViewController<CreateAccountViewModel> {
    // MARK: - Views
    private let contentView = CreateAccountView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .nameEntered(let name):
                    viewModel.setName(name)
                case .emailEntered(let email):
                    viewModel.setEmail(email)
                case .passwordEntered(let password):
                    viewModel.setPassword(password)
                case .repeatPasswordEntered(let password):
                    viewModel.setRepeatPassword(password)
                case .createAccountButtonDidTap:
                    viewModel.createAccount()
                case .backButtonDidTap:
                    viewModel.backToLogin()
                }
            }
            .store(in: &cancellables)
        
        viewModel.eventsPublisher
            .sink { [unowned self] events in
                switch events {
                case .checkEmail(let isEmailValid):
                    contentView.showEmailError(isEmailValid)
                case .checkName(let isNameValid):
                    contentView.showNameError(isNameValid)
                case .checkPassword(let isPasswordValid):
                    contentView.showPasswordError(isPasswordValid)
                case .comparePasswords(let isPasswordsEqual):
                    contentView.showRepeatPasswordError(isPasswordsEqual)
                case .isAllFieldsValid(let isAllFieldValid):
                    contentView.isAllFieldsValid(isAllFieldValid)
                case .userCreatedSuccessfully:
                    successfulCreationAlert()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private extension
private extension CreateAccountViewController {
    func successfulCreationAlert() {
        let alertController = UIAlertController(
            title: Localization.successfullyAlertTitle,
            message: Localization.successfullyCreationMessage,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: Localization.ok, style: .default) { [unowned self] _ in
            viewModel.backToLogin()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
