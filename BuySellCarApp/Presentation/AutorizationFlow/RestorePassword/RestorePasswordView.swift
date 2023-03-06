//
//  RestorePasswordView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 27.02.2023.
//

import UIKit
import Combine
import SnapKit
import Lottie

enum RestorePasswordViewAction {
    case passwordTextFieldDidEnter(String)
    case restorePasswordButtonDidTap
    case close
}

final class RestorePasswordView: BaseView {
    // MARK: - Subviews
    private let lottiePasswordView = LottieAnimationView(name: Constant.animationName)
    private let mainStackView = UIStackView()
    private let passwordTextField = MainTextFieldView(type: .nickname)
    private let restorePasswordButton = MainButton(type: .restorePassword)
    private let closeButton = UIButton(type: .close)
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<RestorePasswordViewAction, Never>()
    
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
        passwordTextField.textFied.textPublisher
            .replaceNil(with: Constant.emptyString)
            .sink { [unowned self] text in actionSubject.send(.passwordTextFieldDidEnter(text)) }
            .store(in: &cancellables)
        passwordTextField.textFied.deleteTextActionPublisher
            .replaceNil(with: Constant.emptyString)
            .sink { [unowned self] text in self.actionSubject.send(.passwordTextFieldDidEnter(text)) }
            .store(in: &cancellables)
        restorePasswordButton.tapPublisher
            .sink { [unowned self] in
                actionSubject.send(.restorePasswordButtonDidTap)
            }
            .store(in: &cancellables)
        closeButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.close) }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        restorePasswordButton.isEnabled = false
        restorePasswordButton.setTitle(Localization.restore, for: .normal)
        restorePasswordButton.backgroundColor = Colors.buttonDarkGray.color
        restorePasswordButton.tintColor = .white
        
        lottiePasswordView.contentMode = .scaleAspectFit
        lottiePasswordView.loopMode = .loop
        lottiePasswordView.animationSpeed = Constant.animationSpeed
        lottiePasswordView.play()
    }
    
    private func setupLayout() {
        addSubview(lottiePasswordView)
        addSubview(closeButton)
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(restorePasswordButton)
        
        lottiePasswordView.snp.makeConstraints {
            $0.top.equalTo(snp.top).inset(Constant.lottiePasswordViewConstraint)
            $0.bottom.equalTo(mainStackView.snp.top)
            $0.trailing.equalTo(snp.trailing).inset(Constant.lottiePasswordViewConstraint)
            $0.leading.equalTo(snp.leading).offset(Constant.lottiePasswordViewConstraint)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(snp.top).inset(Constant.closeButtonConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.closeButtonConstraint)
            $0.height.equalTo(Constant.closeButtonSizeConstraint)
            $0.width.equalTo(Constant.closeButtonSizeConstraint)
        }
        
        mainStackView.axis = .vertical
        mainStackView.spacing = Constant.defaultConstraint
        mainStackView.distribution = .fillProportionally
        mainStackView.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.centerY.equalTo(snp.centerY)
            $0.leading.equalTo(snp.leading).offset(Constant.defaultConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.defaultConstraint)
        }
        restorePasswordButton.snp.makeConstraints { $0.height.equalTo(Constant.restorePasswordButtonHeight) }
    }
}

// MARK: - Internal extension
extension RestorePasswordView {
    func configureToValidState(_ isValid: Bool) {
        restorePasswordButton.isEnabled = isValid
    }
}

// MARK: - View constants
private enum Constant {
    static let emptyString: String = ""
    static let animationName: String = "lottiePassword"
    static let defaultConstraint: CGFloat = 16
    static let animationSpeed: Double = 0.5
    static let closeButtonConstraint: CGFloat = 24
    static let closeButtonSizeConstraint: CGFloat = 32
    static let restorePasswordButtonHeight: CGFloat = 47
    static let lottiePasswordViewConstraint: CGFloat = 32
}

#if DEBUG
import SwiftUI
struct RestorePasswordPreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(RestorePasswordView())
    }
}
#endif
