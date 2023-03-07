//
//  CreateAccountView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.02.2023.
//

import UIKit
import SnapKit
import Combine
import KeyboardLayoutGuide

enum CreateAccountViewAction {
    case nameEntered(String)
    case emailEntered(String)  // TODO: - Fix naming
    case passwordEntered(String)
    case repeatPasswordEntered(String)
    case createAccountButtonDidTap
    case backButtonDidTap
}

final class CreateAccountView: BaseView {
    // MARK: - Subviews
    private let titleLabel = UILabel()
    private let textFieldStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private let nameTextField = MainTextFieldView(type: .name)
    private let emailTextField = MainTextFieldView(type: .email)
    private let passwordTextField = MainTextFieldView(type: .password)
    private let repeatPasswordTextField = MainTextFieldView(type: .confirmPassword)
    private let createAccountButton = MainButton(type: .createAccount)
    private let backButton = MainButton(type: .back)
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<CreateAccountViewAction, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textFieldStackView.distribution = .fillProportionally
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }
    
    private func bindActions() {
        nameTextField.textFied.textPublisher
            .replaceNil(with: Constant.emptyString)
            .sink { [unowned self] text in actionSubject.send(.nameEntered(text)) }
            .store(in: &cancellables)
        emailTextField.textFied.textPublisher
            .replaceNil(with: Constant.emptyString)
            .sink { [unowned self] text in actionSubject.send(.emailEntered(text)) }
            .store(in: &cancellables)
        passwordTextField.textFied.textPublisher
            .replaceNil(with: Constant.emptyString)
            .sink { [unowned self] text in actionSubject.send(.passwordEntered(text)) }
            .store(in: &cancellables)
        repeatPasswordTextField.textFied.textPublisher
            .replaceNil(with: Constant.emptyString)
            .sink { [unowned self] text in actionSubject.send(.repeatPasswordEntered(text)) }
            .store(in: &cancellables)
        createAccountButton.tapPublisher
            .sink { [unowned self] _ in actionSubject.send(.createAccountButtonDidTap) }
            .store(in: &cancellables)
        backButton.tapPublisher
            .sink { [unowned self] _ in actionSubject.send(.backButtonDidTap) }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        backgroundColor = .white
        titleLabel.text = Localization.createAccountTitle
        titleLabel.textAlignment = .center
        titleLabel.font = FontFamily.Montserrat.bold.font(size: Constant.titleLabelFontSize)
        
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = Constant.stackViewSpacing
        textFieldStackView.distribution = .equalSpacing
        
        createAccountButton.isEnabled = false
        
        buttonStackView.axis = .vertical
        buttonStackView.spacing = Constant.stackViewSpacing
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(textFieldStackView)
        addSubview(buttonStackView)
        textFieldStackView.addArrangedSubview(nameTextField)
        textFieldStackView.addArrangedSubview(emailTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        textFieldStackView.addArrangedSubview(repeatPasswordTextField)
        buttonStackView.addArrangedSubview(createAccountButton)
        buttonStackView.addArrangedSubview(backButton)
        
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constant.defaultConstraint)
            $0.leading.equalTo(snp.leading).offset(Constant.defaultConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.defaultConstraint)
        }
        
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.defaultConstraint)
            $0.leading.equalTo(snp.leading).offset(Constant.defaultConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.defaultConstraint)
        }
        
        [createAccountButton, backButton].forEach {
            $0.snp.makeConstraints { $0.height.equalTo(Constant.buttonHeight) }
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.equalTo(snp.leading).offset(Constant.defaultConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.defaultConstraint)
        }
        
        buttonStackView.bottomAnchor.constraint(
            equalTo: keyboardLayoutGuide.topAnchor,
            constant: -Constant.defaultConstraint
        ).isActive = true
    }
}

// MARK: - Internal extension
extension CreateAccountView {
    func isAllFieldsValid(_ isValid: Bool) {
        createAccountButton.isEnabled = isValid
    }
    
    func showNameError(_ isNameValid: Bool) {
        nameTextField.setErrorState(isNameValid)
    }
    
    func showEmailError(_ isEmailValid: Bool) {
        emailTextField.setErrorState(isEmailValid)
    }
    
    func showPasswordError(_ isPasswordValid: Bool) {
        passwordTextField.setErrorState(isPasswordValid)
    }
    
    func showRepeatPasswordError(_ isPasswordValid: Bool) {
        repeatPasswordTextField.setErrorState(isPasswordValid)
    }
}

// MARK: - View constants
private enum Constant {
    static let emptyString: String = ""
    static let stackViewSpacing: CGFloat = 8
    static let defaultConstraint: CGFloat = 16
    static let titleLabelFontSize: CGFloat = 18
    static let buttonHeight: CGFloat = 47
}

#if DEBUG
import SwiftUI
struct CreateAccountPreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(CreateAccountView())
    }
}
#endif
