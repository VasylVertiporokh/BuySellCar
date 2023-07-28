//
//  SignInView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import SnapKit
import UIKit
import Combine

enum SignInViewAction {
    case nickNameDidEnter(String)
    case passwordDidEnter(String)
    case loginDidTap
    case forgotPasswordDidTap
    case createAccountDidTap
}

final class SignInView: BaseView {
    // MARK: - Subviews
    private let scrollView = UIScrollView()
    private let titleLabel = UILabel()
    private let containerStackView = UIStackView()
    private let carImageView = UIImageView()
    private let textFieldsStackView = UIStackView()
    private let nickNameTextField = MainTextFieldView(type: .nickname)
    private let passwordTextField = MainTextFieldView(type: .password)
    private let restorePasswordButton = UIButton(type: .system)
    private let loginButton = MainButton(type: .login)
    private let bottomStackView = UIStackView()
    private let orLabel = UILabel()
    private let createAccountButton = UIButton(type: .system)
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SignInViewAction, Never>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal extension
extension SignInView {
    func setScrollViewOffSet(offSet: CGFloat) {
        scrollView.contentInset.bottom = offSet - safeAreaInsets.bottom
    }
    
    func applyValidation(form: SignInValidationForm) {
        form.email == .notChecked ? nickNameTextField.dropErrorState() : nickNameTextField.setErrorState(form.email.isValid)
        form.password == .notChecked ? passwordTextField.dropErrorState() : passwordTextField.setErrorState(form.password.isValid)
        loginButton.isEnabled = form.isAllValid
    }
}

// MARK: - Private extension
private extension SignInView {
    func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }
    
    func bindActions() {
        nickNameTextField.textField.textPublisher
            .replaceNil(with: "")
            .sink { [unowned self] text in actionSubject.send(.nickNameDidEnter(text)) }
            .store(in: &cancellables)
        passwordTextField.textField.textPublisher
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
    
    func setupUI() {
        backgroundColor = .white
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        
        textFieldsStackView.backgroundColor = .white
        textFieldsStackView.dropShadow()
        
        carImageView.image = Assets.carSellIcon.image
        carImageView.contentMode = .scaleAspectFit
        
        textFieldsStackView.axis = .vertical
        textFieldsStackView.distribution = .fillProportionally
        textFieldsStackView.spacing = Constant.standartConstraint
        
        containerStackView.axis = .vertical
        containerStackView.distribution = .fillProportionally
        containerStackView.spacing = Constant.standartConstraint
        
        bottomStackView.axis = .vertical
        bottomStackView.distribution = .fill
        bottomStackView.spacing = Constant.bottomStackViewSpacing
        
        nickNameTextField.textField.autocapitalizationType = .none
        
        restorePasswordButton.setTitle(Localization.forgotPassword, for: .normal)
        restorePasswordButton.setTitleColor(Colors.buttonDarkGray.color, for: .normal)
        restorePasswordButton.contentHorizontalAlignment = .right
        
        titleLabel.text = "Welcome to BuySellCar"
        titleLabel.textAlignment = .center
        titleLabel.font = Constant.titleLabelFont
        
        orLabel.textAlignment = .center
        orLabel.text = Localization.or
        orLabel.textColor = .lightGray
        
        createAccountButton.setTitle(Localization.createNewAccount, for: .normal)
        createAccountButton.backgroundColor = Colors.buttonYellow.color
        createAccountButton.tintColor = Colors.buttonDarkGray.color
        createAccountButton.titleLabel?.font = Constant.createAccountButtonFont
        createAccountButton.setTitleColor(Colors.buttonDarkGray.color, for: .normal)
        createAccountButton.layer.cornerRadius = Constant.createAccountButtonRadius
    }
    
    func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(containerStackView)
        
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewInset
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(textFieldsStackView)
        containerStackView.addArrangedSubview(restorePasswordButton)
        containerStackView.addArrangedSubview(bottomStackView)
        
        textFieldsStackView.isLayoutMarginsRelativeArrangement = true
        textFieldsStackView.layoutMargins = Constant.textFieldsStackViewInset
        
        textFieldsStackView.addArrangedSubview(carImageView)
        textFieldsStackView.addArrangedSubview(nickNameTextField)
        textFieldsStackView.addArrangedSubview(passwordTextField)
        
        bottomStackView.addArrangedSubview(loginButton)
        bottomStackView.addArrangedSubview(createAccountButton)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
            $0.width.equalTo(snp.width)
        }
        
        containerStackView.snp.makeConstraints {
            $0.centerY.equalTo(scrollView.snp.centerY)
            $0.top.equalTo(scrollView.snp.top).offset(Constant.containerStackViewTopConstraint).priority(.low)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        carImageView.snp.makeConstraints { $0.height.equalTo(Constant.carImageViewHeight) }
        loginButton.snp.makeConstraints { $0.height.equalTo(Constant.loginButtonHeight) }
        restorePasswordButton.snp.makeConstraints { $0.height.equalTo(Constant.buttonHeight) }
        createAccountButton.snp.makeConstraints { $0.height.equalTo(Constant.loginButtonHeight) }
    }
    
}

// MARK: - View constants
private enum Constant {
    static let containerStackViewInset: UIEdgeInsets = .init(top: .zero, left: 16, bottom: .zero, right: 16)
    static let textFieldsStackViewInset: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    static let titleLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 24)
    static let createAccountButtonFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 16)
    static let createAccountButtonRadius: CGFloat = 10
    static let bottomStackViewSpacing: CGFloat = 8
    static let containerStackViewTopConstraint: CGFloat = 150
    static let standartConstraint: CGFloat = 16
    static let carImageViewHeight: CGFloat = 100
    static let buttonHeight: CGFloat = 20
    static let loginButtonHeight: CGFloat = 47
}
