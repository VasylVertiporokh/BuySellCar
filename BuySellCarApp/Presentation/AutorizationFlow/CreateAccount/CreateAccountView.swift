//
//  CreateAccountView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.02.2023.
//

import UIKit
import SnapKit
import Combine
import PhoneNumberKit

enum CreateAccountViewAction {
    case nameEntered(String)
    case emailEntered(String)  // TODO: - Fix naming
    case passwordEntered(String)
    case repeatPasswordEntered(String)
    case phoneEntered(String)
    case isPhoneValid(Bool)
    case createAccountButtonDidTap
    case backButtonDidTap
}

final class CreateAccountView: BaseView {    
    // MARK: - Subviews
    private let scrollView: UIScrollView = UIScrollView()
    private let containerStackView: UIStackView = UIStackView()
    private let titleLabel = UILabel()
    private let textFieldStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private let nameTextField = MainTextFieldView(type: .name)
    private let emailTextField = MainTextFieldView(type: .email)
    private let passwordTextField = MainTextFieldView(type: .password)
    private let repeatPasswordTextField = MainTextFieldView(type: .confirmPassword)
    private let phoneTextFieldView = UIView()
    private let phoneTextField = PhoneNumberTextField()
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
}

// MARK: - Internal extension
extension CreateAccountView {
    func setScrollViewOffSet(offSet: CGFloat) {
        scrollView.contentInset.bottom = offSet - safeAreaInsets.bottom
    }
    
    func applyValidation(form: CreateAccountValidationForm) {
        if form.name != .notChecked {
            nameTextField.setErrorState(form.name.isValid)
        }

        if form.email != .notChecked {
            emailTextField.setErrorState(form.email.isValid)
        }
        
        if form.password != .notChecked {
            passwordTextField.setErrorState(form.password.isValid)
        }
        
        if form.confirmPassword != .notChecked {
            repeatPasswordTextField.setErrorState(form.confirmPassword.isValid)
        }
        createAccountButton.isEnabled = form.isAllValid
    }
}

// MARK: - Private extension
private extension CreateAccountView {
    func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }
    
    func bindActions() {
        nameTextField.textField.textPublisher
            .replaceNil(with: Constant.emptyString)
            .sink { [unowned self] text in actionSubject.send(.nameEntered(text)) }
            .store(in: &cancellables)
        emailTextField.textField.textPublisher
            .replaceNil(with: Constant.emptyString)
            .sink { [unowned self] text in actionSubject.send(.emailEntered(text)) }
            .store(in: &cancellables)
        passwordTextField.textField.textPublisher
            .replaceNil(with: Constant.emptyString)
            .sink { [unowned self] text in actionSubject.send(.passwordEntered(text)) }
            .store(in: &cancellables)
        repeatPasswordTextField.textField.textPublisher
            .replaceNil(with: Constant.emptyString)
            .sink { [unowned self] text in actionSubject.send(.repeatPasswordEntered(text)) }
            .store(in: &cancellables)
        phoneTextField.textPublisher
            .replaceNil(with: "")
            .sink { [unowned self] text in actionSubject.send(.phoneEntered(text))
                actionSubject.send(.isPhoneValid(phoneTextField.isValidNumber))
            }
            .store(in: &cancellables)
        createAccountButton.tapPublisher
            .sink { [unowned self] _ in actionSubject.send(.createAccountButtonDidTap) }
            .store(in: &cancellables)
        backButton.tapPublisher
            .sink { [unowned self] _ in actionSubject.send(.backButtonDidTap) }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        backgroundColor = .white
        titleLabel.text = Localization.createAccountTitle
        titleLabel.textAlignment = .center
        titleLabel.font = FontFamily.Montserrat.bold.font(size: Constant.titleLabelFontSize)
        
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        
        containerStackView.axis = .vertical
        containerStackView.spacing = Constant.mainSpacing
        containerStackView.distribution = .fillProportionally
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewMargins
        
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = Constant.stackViewSpacing
        
        phoneTextFieldView.layer.borderWidth = Constant.borderWidth
        phoneTextFieldView.layer.borderColor = Colors.buttonDarkGray.color.cgColor
        phoneTextFieldView.layer.cornerRadius = Constant.phoneTextFieldOffset
        
        phoneTextField.withFlag = true
        phoneTextField.withExamplePlaceholder = true
        phoneTextField.withPrefix = true
        phoneTextField.withFlag = true
        phoneTextField.withDefaultPickerUI = true
        
        createAccountButton.isEnabled = false
        
        buttonStackView.axis = .vertical
        buttonStackView.spacing = Constant.stackViewSpacing
    }
    
    func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(textFieldStackView)
        containerStackView.addArrangedSubview(buttonStackView)
        
        textFieldStackView.addArrangedSubview(nameTextField)
        textFieldStackView.addArrangedSubview(emailTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        textFieldStackView.addArrangedSubview(repeatPasswordTextField)
        textFieldStackView.addArrangedSubview(phoneTextFieldView)
        
        phoneTextFieldView.addSubview(phoneTextField)
        buttonStackView.addArrangedSubview(createAccountButton)
        buttonStackView.addArrangedSubview(backButton)
        
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
            $0.width.equalTo(snp.width)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(Constant.defaultConstraint)
            $0.leading.equalTo(scrollView.snp.leading).offset(Constant.defaultConstraint)
            $0.trailing.equalTo(scrollView.snp.trailing).inset(Constant.defaultConstraint)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.defaultConstraint)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        phoneTextFieldView.snp.makeConstraints { $0.height.equalTo(Constant.phoneTextFieldViewHeight) }
        
        phoneTextField.snp.makeConstraints {
            $0.top.equalTo(phoneTextFieldView.snp.top)
            $0.bottom.equalTo(phoneTextFieldView.snp.bottom)
            $0.leading.equalTo(phoneTextFieldView.snp.leading).offset(Constant.phoneTextFieldOffset)
            $0.trailing.equalTo(phoneTextFieldView.snp.trailing).inset(Constant.phoneTextFieldOffset)
        }
        
        [createAccountButton, backButton].forEach {
            $0.snp.makeConstraints { $0.height.equalTo(Constant.buttonHeight) }
        }
    }
}

// MARK: - View constants
private enum Constant {
    static let containerStackViewMargins: UIEdgeInsets = .init(top: 16, left: 16, bottom: .zero, right: 16)
    static let borderWidth: CGFloat = 1
    static let mainSpacing: CGFloat = 32
    static let emptyString: String = ""
    static let stackViewSpacing: CGFloat = 8
    static let defaultConstraint: CGFloat = 16
    static let titleLabelFontSize: CGFloat = 18
    static let buttonHeight: CGFloat = 47
    static let phoneTextFieldViewHeight: CGFloat = 40
    static let phoneTextFieldOffset: CGFloat = 10
}
