//
//  SignInView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import SnapKit
import Combine
import KeyboardLayoutGuide

enum SignInViewAction {
    case nickNameDidEnter(String)
    case passwordDidEnter(String)
    case loginDidTap
    case forgotPasswordDidTap
    case createAccountDidTap
}

final class SignInView: BaseView {
    // MARK: - Subviews
    private let carImageView = UIImageView()
    private let textFieldsStackView = UIStackView()
    private let nickNameTextField = MainTextFieldView(type: .nickname)
    private let passwordTextField = MainTextFieldView(type: .password)
    private let restorePasswordButton = UIButton(type: .system)
    private let loginButton = MainButton(type: .login)
    private let bottomStackView = UIStackView()
    private let orLabel = UILabel()
    private let createAccountButton = UIButton(type: .system)
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SignInViewAction, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
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
        nickNameTextField.textFied.textPublisher
            .replaceNil(with: "")
            .sink { [unowned self] text in actionSubject.send(.nickNameDidEnter(text)) }
            .store(in: &cancellables)
        passwordTextField.textFied.textPublisher
            .replaceNil(with: "")
            .sink { [unowned self] text in actionSubject.send(.passwordDidEnter(text)) }
            .store(in: &cancellables)
        loginButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.loginDidTap) }
            .store(in: &cancellables)
        restorePasswordButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.forgotPasswordDidTap) }
            .store(in: &cancellables)
        createAccountButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.createAccountDidTap) }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        carImageView.image = Assets.carSellIcon.image
        carImageView.contentMode = .scaleAspectFit
        
        textFieldsStackView.axis = .vertical
        textFieldsStackView.distribution = .fillProportionally
        textFieldsStackView.spacing = Constant.standartConstraint
        
        bottomStackView.axis = .vertical
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = Constant.standartConstraint
        
        restorePasswordButton.setTitle(Localization.forgotPassword, for: .normal)
        restorePasswordButton.setTitleColor(Colors.buttonDarkGray.color, for: .normal)
        
        orLabel.textAlignment = .center
        orLabel.text = Localization.or
        orLabel.textColor = .lightGray
        
        createAccountButton.setTitle(Localization.createNewAccount, for: .normal)
        createAccountButton.setTitleColor(Colors.buttonDarkGray.color, for: .normal)
    }
    
    private func setupLayout() {
        addSubview(textFieldsStackView)
        addSubview(loginButton)
        addSubview(bottomStackView)
        textFieldsStackView.addArrangedSubview(carImageView)
        textFieldsStackView.addArrangedSubview(nickNameTextField)
        textFieldsStackView.addArrangedSubview(passwordTextField)
        textFieldsStackView.addArrangedSubview(restorePasswordButton)
        textFieldsStackView.addArrangedSubview(bottomStackView)
        textFieldsStackView.addArrangedSubview(UIView())
        
        bottomStackView.addArrangedSubview(orLabel)
        bottomStackView.addArrangedSubview(createAccountButton)
        
        carImageView.snp.makeConstraints { $0.height.equalTo(Constant.carImageViewHeight) }
        
        textFieldsStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constant.standartConstraint)
            $0.leading.equalTo(snp.leading).offset(Constant.standartConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.standartConstraint)
        }
        
        loginButton.snp.makeConstraints {
            $0.leading.equalTo(snp.leading).offset(Constant.standartConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.standartConstraint)
            $0.height.equalTo(Constant.loginButtonHeight)
        }
        loginButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -Constant.standartConstraint).isActive = true
        
        restorePasswordButton.snp.makeConstraints { $0.height.equalTo(Constant.buttonHeight) }
        createAccountButton.snp.makeConstraints { $0.height.equalTo(Constant.buttonHeight) }
    }
}

// MARK: - Internal extension
extension SignInView {
    func setIsNicknameValid(_ isValid: Bool) {
        nickNameTextField.setErrorState(isValid)
    }
    
    func setIsPasswordValid(_ isValid: Bool) {
        passwordTextField.setErrorState(isValid)
    }
    
    func isButtonEnabled(_ isEnabled: Bool) {
        loginButton.isEnabled = isEnabled
    }
}

// MARK: - View constants
private enum Constant {
    static let standartConstraint: CGFloat = 16
    static let carImageViewHeight: CGFloat = 150
    static let buttonHeight: CGFloat = 20
    static let loginButtonHeight: CGFloat = 47
}

#if DEBUG
import SwiftUI
struct SignInPreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(SignInView())
    }
}
#endif
