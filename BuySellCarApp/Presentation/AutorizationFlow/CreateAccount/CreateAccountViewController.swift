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
                case .phoneEntered(let phoneNumber):
                    viewModel.setUserPhone(phoneNumber)
                case .isPhoneValid(let isPhoneValid):
                    viewModel.setIsPhoneValid(isPhoneValid)
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
                case .userCreatedSuccessfully:
                    successfulCreationAlert()
                }
            }
            .store(in: &cancellables)
        
        viewModel.validationPublisher
            .removeDuplicates()
            .sink { [unowned self] in contentView.applyValidation(form: $0) }
            .store(in: &cancellables)
        
        keyboardHeightPublisher
            .sink { [unowned self] in contentView.setScrollViewOffSet(offSet: $0) }
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
