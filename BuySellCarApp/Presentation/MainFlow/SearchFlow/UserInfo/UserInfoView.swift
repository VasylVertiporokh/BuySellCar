//
//  UserInfoView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 01.03.2023.
//

import UIKit
import SnapKit
import Combine

enum UserInfoViewAction {

}

final class UserInfoView: BaseView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let nameTitleLabel = UILabel()
    private let nameLabel = UILabel()
    private let emailTitleLabel = UILabel()
    private let emailLabel = UILabel()
    private let userTokenTitleLabel = UILabel()
    private let userTokenLabel = UILabel()
    private let userLocaleTitleLabel = UILabel()
    private let userLocaleLabel = UILabel()
    private let objectIDTitleLabel = UILabel()
    private let objectIDLabel = UILabel()
    private let ownerIDTitleLabel = UILabel()
    private let ownerIDLabel = UILabel()

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<UserInfoViewAction, Never>()

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
    }

    private func setupUI() {
        backgroundColor = .white
        containerStackView.spacing = 8
        containerStackView.axis = .vertical
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        
        nameTitleLabel.text = "Name"
        emailTitleLabel.text = "Email"
        userTokenTitleLabel.text = "Token"
        userLocaleTitleLabel.text = "Locale"
        objectIDTitleLabel.text = "ObjectID"
        ownerIDTitleLabel.text = "OwnerID"
        
        [
            nameTitleLabel,
            emailTitleLabel,
            userTokenTitleLabel,
            userLocaleTitleLabel,
            objectIDTitleLabel,
            ownerIDTitleLabel
        ].forEach {
            $0.textColor = Colors.buttonDarkGray.color
            $0.textAlignment = .left
            $0.font = FontFamily.Montserrat.extraBold.font(size: 14)
            $0.backgroundColor = .lightGray.withAlphaComponent(0.2)
        }
        
        [nameLabel, emailLabel, userTokenLabel, userLocaleLabel, objectIDLabel, ownerIDLabel].forEach {
            $0.textColor = Colors.buttonDarkGray.color
            $0.textAlignment = .left
            $0.font = FontFamily.Montserrat.regular.font(size: 16)
            $0.numberOfLines = .zero
        }
    }
    
    func setUserInfo(model: UserDomainModel) {
        nameLabel.text = model.userName
        emailLabel.text = model.email
        userTokenLabel.text = "Token"
        userLocaleLabel.text = model.userAvatar
        objectIDLabel.text = model.objectID
        ownerIDLabel.text = model.ownerID
    }

    private func setupLayout() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(nameTitleLabel)
        containerStackView.addArrangedSubview(nameLabel)
        containerStackView.addArrangedSubview(emailTitleLabel)
        containerStackView.addArrangedSubview(emailLabel)
        containerStackView.addArrangedSubview(userTokenTitleLabel)
        containerStackView.addArrangedSubview(userTokenLabel)
        containerStackView.addArrangedSubview(userLocaleTitleLabel)
        containerStackView.addArrangedSubview(userLocaleLabel)
        containerStackView.addArrangedSubview(objectIDTitleLabel)
        containerStackView.addArrangedSubview(objectIDLabel)
        containerStackView.addArrangedSubview(ownerIDTitleLabel)
        containerStackView.addArrangedSubview(ownerIDLabel)
        containerStackView.addSpacer()
        
        containerStackView.snp.makeConstraints {
            $0.left.right.top.bottom.equalTo(0)
        }
    }
}

// MARK: - View constants
private enum Constant {
}

#if DEBUG
import SwiftUI
struct UserInfoPreview: PreviewProvider {
    
    static var previews: some View {
        ViewRepresentable(UserInfoView())
    }
}
#endif
