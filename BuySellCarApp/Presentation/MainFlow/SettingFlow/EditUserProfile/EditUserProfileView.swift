//
//  EditUserProfileView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 20.03.2023.
//

import UIKit
import Combine
import Kingfisher
import SnapKit

enum EditUserProfileViewAction {
    case logout
}

final class EditUserProfileView: BaseView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let userAvatarStackView = UIStackView()
    private let userAvatarImageView = UIImageView()
    private let userNameTitleLabel = UILabel()
    private let userNameLabel = UILabel()
    private let userEmailTitleLabel = UILabel()
    private let userEmailLabel = UILabel()
    private let logoutButton = MainButton(type: .logout)

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<EditUserProfileViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal extension
extension EditUserProfileView {
    func setUserInfo(_ model: UserDomainModel?) {
        guard let model = model else {
            return
        }
        userNameLabel.text = model.userName
        userEmailLabel.text = model.email
        userAvatarImageView.kf.setImage(
            with: URL(string: model.userAvatar ?? ""),
            placeholder: Assets.userPlaceholder.image,
            options: [.forceRefresh]
        )
    }
}

// MARK: - Private extension
private extension EditUserProfileView {
    func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }

    func bindActions() {
        logoutButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.logout) }
            .store(in: &cancellables)
    }

    func setupUI() {
        backgroundColor = .systemGroupedBackground
        containerStackView.backgroundColor = .white
        containerStackView.dropShadow()
        containerStackView.layer.borderColor = Colors.buttonDarkGray.color.cgColor
        
        userAvatarImageView.image = Assets.userPlaceholder.image
        userAvatarImageView.contentMode = .scaleAspectFill
        userAvatarImageView.layer.cornerRadius = 60
        userAvatarImageView.clipsToBounds = true
        userAvatarImageView.layer.borderColor = Colors.buttonDarkGray.color.cgColor
        userAvatarImageView.layer.borderWidth = 0.3
        
        userNameTitleLabel.text = "Name"
        userEmailTitleLabel.text = "Email"
        
        userNameLabel.text = "Vasia Vertiporoh"
        userEmailLabel.text = "vasiaVasia@gmial.com"
        
        [userNameTitleLabel, userEmailTitleLabel].forEach {
            $0.font = FontFamily.Montserrat.semiBold.font(size: 14)
            $0.textAlignment = .left
        }
        
        [userNameLabel, userEmailLabel].forEach {
            $0.textAlignment = .left
            $0.font = FontFamily.Montserrat.regular.font(size: 16)
            $0.numberOfLines = .zero
        }
    }

    func setupLayout() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(userAvatarStackView)
        userAvatarStackView.addArrangedSubview(userAvatarImageView)
        addSubview(logoutButton)
        
        userAvatarStackView.axis = .vertical
        userAvatarStackView.distribution = .fill
        userAvatarStackView.alignment = .center
        
        containerStackView.axis = .vertical
        containerStackView.distribution = .fillProportionally
        containerStackView.spacing = 4
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        containerStackView.addArrangedSubview(userNameTitleLabel)
        containerStackView.addArrangedSubview(userNameLabel)
        containerStackView.addArrangedSubview(userEmailTitleLabel)
        containerStackView.addArrangedSubview(userEmailLabel)
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalTo(snp.leading).offset(16)
            $0.trailing.equalTo(snp.trailing).inset(16)
        }
        
        userAvatarImageView.snp.makeConstraints {
            $0.width.height.equalTo(120).priority(.high)
        }
        
        logoutButton.snp.makeConstraints {
            $0.height.equalTo(47)
            $0.leading.equalTo(snp.leading).offset(16)
            $0.trailing.equalTo(snp.trailing).inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16)
        }
    }
}

// MARK: - View constants
private enum Constant {
    
}

#if DEBUG
import SwiftUI
struct EditUserProfilePreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(EditUserProfileView())
    }
}
#endif
