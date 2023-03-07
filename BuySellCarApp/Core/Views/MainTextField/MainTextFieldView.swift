//
//  MainTextFieldView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 24.02.2023.
//

import UIKit
import SnapKit

final class MainTextFieldView: UIStackView {
    // MARK: - Privtae properties
    private let type: TextFieldType
    
    // MARK: - Subviews
    private(set) lazy var textFied = MainTextField(type: type)
    private let errorLabel = UILabel()
    
    // MARK: - Init
    init(type: TextFieldType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal extension
extension MainTextFieldView {    
    func setErrorState(_ isFieldValid: Bool) {
        UIView.animate(withDuration: Constants.animationDuration,
                       delay: .zero,
                       usingSpringWithDamping: Constants.animationDamping,
                       initialSpringVelocity: Constants.initialSpringVelocity,
                       options: [],
                       animations: {
            self.textFied.layer.borderColor = isFieldValid ? Colors.buttonDarkGray.color.cgColor : UIColor.red.cgColor
            self.errorLabel.alpha = isFieldValid ? .zero : Constants.initialSpringVelocity
            self.errorLabel.isHidden = isFieldValid
            self.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - Private extension
private extension MainTextFieldView {
    func configure() {
        configureStackView()
        addSubviews()
        configureTextField()
        configureErrorLabel()
    }
    
    func configureStackView() {
        axis = .vertical
        spacing = Constants.stackViewSpacing
    }
    
    func addSubviews() {
        addArrangedSubview(textFied)
        addArrangedSubview(errorLabel)
        textFied.snp.makeConstraints { $0.height.equalTo(Constants.textFieldHeight) }
        errorLabel.snp.makeConstraints { $0.height.equalTo(Constants.fontSize) }
    }
    
    func configureTextField() {
        textFied.layer.cornerRadius = Constants.cornerRadius
        textFied.layer.borderColor = Colors.buttonDarkGray.color.cgColor
        textFied.layer.borderWidth = Constants.borderWidth
    }
    
    func configureErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.text = type.errorMessage
        errorLabel.textColor = .systemRed
        errorLabel.font = FontFamily.Montserrat.semiBold.font(size: Constants.fontSize)
    }
}

// MARK: - Constants
private enum Constants {
    static let stackViewSpacing: CGFloat = 8
    static let textFieldHeight: CGFloat = 47
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 1
    static let fontSize: CGFloat = 12
    static let animationDuration: Double = 0.33
    static let animationDamping: Double = 0.9
    static let initialSpringVelocity: Double = 1
}
