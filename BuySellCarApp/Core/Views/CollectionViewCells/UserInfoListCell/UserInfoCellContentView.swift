//
//  UserInfoCellContentView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 14.03.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class UserInfoCellContentView: UIView, UIContentView {
    // MARK: - Internal properties
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? UserInfoCellContentConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - Private properties
    private var currentConfiguration: UserInfoCellContentConfiguration!
    
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let labelStackView = UIStackView()
    private let userAvatar = UIImageView()
    private let nicknameLabel = UILabel()
    private let infoLabel = UILabel()
    
    // MARK: - Init
    init(configuration: UserInfoCellContentConfiguration) {
        super.init(frame: .zero)
        setupLayout()
        setupUI()
        apply(configuration: configuration)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private extension
private extension UserInfoCellContentView {
    func setupUI() {
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.layer.cornerRadius = Constants.userAvatarCornerRadius
        userAvatar.layer.borderWidth = 0.3
        userAvatar.layer.borderColor = Colors.buttonDarkGray.color.cgColor
        userAvatar.clipsToBounds = true
        
        nicknameLabel.numberOfLines = .zero
        nicknameLabel.font = Constants.nicknameLabelFont
        
        infoLabel.text = "Welcome in BuySellCar!"
        infoLabel.numberOfLines = .zero
        infoLabel.font = Constants.infoLabelFont
    }
    
    func setupLayout() {
        addSubview(containerStackView)
        containerStackView.snp.makeConstraints { $0.edges.equalTo(layoutMarginsGuide.snp.edges) }
        containerStackView.addArrangedSubview(userAvatar)
        containerStackView.addArrangedSubview(labelStackView)
        labelStackView.addArrangedSubview(nicknameLabel)
        labelStackView.addArrangedSubview(infoLabel)
        
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.spacing = Constants.containerStackViewSpacing
        
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillEqually
        labelStackView.spacing = Constants.labelStackViewSpacing
        
        userAvatar.snp.makeConstraints {
            $0.height.width.equalTo(Constants.userAvatarHeight)
        }
    }
    
    private func apply(configuration: UserInfoCellContentConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        userAvatar.kf.setImage(
            with: configuration.userAvatar,
            placeholder: Assets.userPlaceholder.image,
            options: [.forceRefresh]
        )
        currentConfiguration = configuration
        nicknameLabel.text = configuration.userNickname
    }
}

private enum Constants {
    static let containerStackViewSpacing: CGFloat = 16
    static let labelStackViewSpacing: CGFloat = 4
    static let userAvatarHeight: CGFloat = 96
    static let userAvatarCornerRadius: CGFloat = 48
    static let nicknameLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 16)
    static let infoLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 12)
}
