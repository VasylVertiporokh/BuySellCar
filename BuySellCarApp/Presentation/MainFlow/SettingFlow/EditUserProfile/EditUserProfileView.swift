//
//  EditUserProfileView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 20.03.2023.
//

import Combine
import Kingfisher
import SnapKit
import UIKit
import PhoneNumberKit

enum EditUserProfileViewAction {
    case logout
    case updateUserAvatar
    case deleteUserAvatar
    case saveChanges
    case nameChanged(String)
    case phoneChanged(phoneNumber:String, isValid: Bool)
    case isOwner(Bool)
    case withWhatsAppAccount(Bool)
}

final class EditUserProfileView: BaseView {
    // MARK: - Subviews
    private let scrollView: UIScrollView = UIScrollView()
    private let containerStackView = UIStackView()
    private let editUserStackView = UIStackView()
    private let userAvatarStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private let phoneTextFieldStackView = UIStackView()
    private let userAvatarImageView = UIImageView()
    private let userNameTitleLabel = UILabel()
    private let userEmailTitleLabel = UILabel()
    private let userEmailLabel = UILabel()
    private let phoneTitleLabel = UILabel()
    private let editImageView = UIImageView(image: Assets.editIcon.image)
    private let userNameTextField = MainTextFieldView(type: .editable)
    private let phoneTextField = PhoneNumberTextField()
    private let logoutButton = MainButton(type: .logout)
    private let saveChangesButton = MainButton(type: .save)
    private let editAvatarButton = UIButton(type: .system)
    
    private let additionalInfoTitleLabel = UILabel()
    private let additionalInfoStackView = UIStackView()
    private let dealerStackView = UIStackView()
    private let dealerTitleLabel = UILabel()
    private let dealerSwitch = UISwitch()
    
    private let whatsAppStackView = UIStackView()
    private let whatsAppTitleLabel = UILabel()
    private let whatsAppSwitch = UISwitch()
    
    // MARK: - UIActions
    private lazy var uploadAvatarAction: UIAction = {
        let action = UIAction(title: "Update photo", image: Assets.addAvatarIcon.image) { [weak self] _ in
            guard let self = self else { return }
            self.actionSubject.send(.updateUserAvatar)
        }
        action.setFont(FontFamily.Montserrat.medium.font(size: Constant.standartConstraint))
        return action
    }()
    
    private lazy var deleteAvatarAction: UIAction = {
        let action = UIAction(title: "Delete photo", image: Assets.deleteAvatarIcon.image) { [weak self] _ in
            guard let self = self else { return }
            self.actionSubject.send(.deleteUserAvatar)
        }
        action.setFont(FontFamily.Montserrat.medium.font(size: Constant.standartConstraint))
        return action
    }()
    
    // MARK: - Action subject
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<EditUserProfileViewAction, Never>()
    
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
extension EditUserProfileView {
    func configureView(_ model: UserDomainModel?) {
        guard let model = model else {
            return
        }
        configUIMenu(isAvatarAvailable: model.userAvatar.isNilOrEmpty)
        userNameTextField.textField.text = model.userName
        userEmailLabel.text = model.email
        phoneTextField.text = model.phoneNumber
        whatsAppSwitch.isOn = model.withWhatsAppAccount
        dealerSwitch.isOn = model.isCommercialSales
        userAvatarImageView.kf.setImage(
            with: URL(string: model.userAvatar ?? ""),
            placeholder: Assets.userPlaceholder.image,
            options: [.forceRefresh]
        )
    }
    
    func applyValidation(form: EditProfileValidation) {
        switch form.name {
        case .notChecked, .valid:
            userNameTextField.setErrorState(form.name.isValid)
        case .invalid:
            userNameTextField.setErrorState(form.name.isValid)
        }
        
        switch form.phoneNumber {
        case .notChecked, .valid:
            phoneTextFieldStackView.layer.borderColor = Colors.buttonDarkGray.color.cgColor
        case .invalid:
            phoneTextFieldStackView.layer.borderColor = UIColor.red.cgColor
        }
        saveChangesButton.isEnabled = form.isAllValid
    }
    
    func setScrollViewOffSet(offSet: CGFloat) {
        scrollView.contentInset.bottom = offSet - safeAreaInsets.bottom
    }
}

// MARK: - Private extension
private extension EditUserProfileView {
    func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
        setupAction()
    }
    
    func bindActions() {
        logoutButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.logout) }
            .store(in: &cancellables)
        
        saveChangesButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.saveChanges) }
            .store(in: &cancellables)
        
        userNameTextField.textField.textPublisher
            .replaceNil(with: "")
            .sink { [unowned self] in actionSubject.send(.nameChanged($0)) }
            .store(in: &cancellables)
        
        phoneTextField.textPublisher
            .replaceNil(with: "")
            .sink { [unowned self] in
                actionSubject.send(.phoneChanged(phoneNumber: $0, isValid: phoneTextField.isValidNumber))
            }
            .store(in: &cancellables)
        
        dealerSwitch.isOnPublisher
            .sink { [unowned self] in
                actionSubject.send(.isOwner($0))
            }
            .store(in: &cancellables)
        
        whatsAppSwitch.isOnPublisher
            .sink { [unowned self] in
                actionSubject.send(.withWhatsAppAccount($0))
            }
            .store(in: &cancellables)
    }
    
    func configUIMenu(isAvatarAvailable: Bool) {
        deleteAvatarAction.attributes = isAvatarAvailable ? .hidden : []
        editAvatarButton.showsMenuAsPrimaryAction = true
        editAvatarButton.menu = UIMenu(children: [uploadAvatarAction, deleteAvatarAction])
    }
    
    func setupUI() {
        backgroundColor = .systemGroupedBackground
        
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        
        editUserStackView.backgroundColor = .white
        editUserStackView.dropShadow()
        editUserStackView.layer.borderColor = Colors.buttonDarkGray.color.cgColor
        
        userAvatarImageView.image = Assets.userPlaceholder.image
        userAvatarImageView.contentMode = .scaleAspectFill
        userAvatarImageView.layer.cornerRadius = Constant.userAvatarImageViewRadius
        userAvatarImageView.clipsToBounds = true
        userAvatarImageView.layer.borderColor = Colors.buttonDarkGray.color.cgColor
        userAvatarImageView.layer.borderWidth = Constant.userAvatarBorderWidth
        
        phoneTextField.withFlag = true
        phoneTextField.withExamplePlaceholder = true
        phoneTextField.withPrefix = true
        phoneTextField.withFlag = true
        phoneTextField.withDefaultPickerUI = true
        
        userNameTitleLabel.text = "Name"
        userEmailTitleLabel.text = "Email"
        phoneTitleLabel.text = "Phone"
        dealerTitleLabel.text = "Commercial sales"
        whatsAppTitleLabel.text = "Do you have a WhatsApp account?"
        additionalInfoTitleLabel.text = "Additional info:"
        
        phoneTextFieldStackView.layer.borderColor = Colors.buttonDarkGray.color.cgColor
        phoneTextFieldStackView.layer.borderWidth = Constant.borderWidth
        phoneTextFieldStackView.layer.cornerRadius = Constant.cornerRadius
        
        editAvatarButton.setImage(Assets.addAvatarIcon.image.withRenderingMode(.alwaysOriginal), for: .normal)
        editAvatarButton.imageView?.tintColor = .red
        editAvatarButton.contentVerticalAlignment = .fill
        editAvatarButton.contentHorizontalAlignment = .fill
        editAvatarButton.imageEdgeInsets = .all(.zero)
        
        [dealerSwitch, whatsAppSwitch].forEach {
            $0.onTintColor = Colors.buttonDarkGray.color
        }
        
        [userNameTitleLabel, phoneTitleLabel, additionalInfoTitleLabel].forEach {
            $0.font = Constant.titleLabelsFont
            $0.textAlignment = .left
        }
        
        [dealerTitleLabel, whatsAppTitleLabel].forEach {
            $0.font = Constant.additionalLabelFont
            $0.textAlignment = .left
            $0.textColor = Colors.buttonDarkGray.color.withAlphaComponent(0.8)
        }
        
        [userEmailTitleLabel, userEmailLabel].forEach {
            $0.textAlignment = .left
            $0.font = FontFamily.Montserrat.regular.font(size: Constant.standartConstraint)
            $0.textColor = Colors.buttonDarkGray.color.withAlphaComponent(0.8)
        }
    }
    
    func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(editUserStackView)
        containerStackView.addArrangedSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(saveChangesButton)
        buttonStackView.addArrangedSubview(logoutButton)
        
        containerStackView.axis = .vertical
        containerStackView.spacing = Constant.containerStackViewSpacing
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewMargins
        
        editUserStackView.addArrangedSubview(userAvatarStackView)
        userAvatarStackView.addArrangedSubview(userAvatarImageView)
        userAvatarStackView.addArrangedSubview(userEmailTitleLabel)
        userAvatarStackView.addArrangedSubview(userEmailLabel)
        
        editUserStackView.axis = .vertical
        editUserStackView.spacing = Constant.stackViewSpacing
        editUserStackView.isLayoutMarginsRelativeArrangement = true
        editUserStackView.layoutMargins = .init(
            top: Constant.stackViewInset,
            left: Constant.stackViewInset,
            bottom: Constant.standartConstraint,
            right: Constant.stackViewInset
        )
        
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = Constant.standartConstraint

        userAvatarStackView.axis = .vertical
        userAvatarStackView.distribution = .fill
        userAvatarStackView.alignment = .center
        userAvatarStackView.spacing = Constant.stackViewSpacing
        
        phoneTextFieldStackView.axis = .horizontal
        phoneTextFieldStackView.spacing = Constant.stackViewSpacing
        phoneTextFieldStackView.distribution = .equalCentering
        phoneTextFieldStackView.alignment = .center
        phoneTextFieldStackView.isLayoutMarginsRelativeArrangement = true
        phoneTextFieldStackView.layoutMargins = .init(
            top: .zero,
            left: Constant.stackViewInset,
            bottom: .zero,
            right: Constant.standartConstraint
        )
        
        additionalInfoStackView.axis = .vertical
        additionalInfoStackView.spacing = Constant.additionalInfoStackViewSpacing
        additionalInfoStackView.isLayoutMarginsRelativeArrangement = true
        additionalInfoStackView.layoutMargins.top = Constant.additionalInfoStackViewTopInset
        dealerStackView.axis = .horizontal
        
        editUserStackView.addArrangedSubview(userNameTitleLabel)
        editUserStackView.addArrangedSubview(userNameTextField)
        editUserStackView.addArrangedSubview(phoneTitleLabel)
        editUserStackView.addArrangedSubview(phoneTextFieldStackView)
        editUserStackView.addArrangedSubview(additionalInfoStackView)
        
        phoneTextFieldStackView.addArrangedSubview(phoneTextField)
        phoneTextFieldStackView.addArrangedSubview(editImageView)
    
        additionalInfoStackView.addArrangedSubview(additionalInfoTitleLabel)
        additionalInfoStackView.addArrangedSubview(dealerStackView)
        additionalInfoStackView.addArrangedSubview(whatsAppStackView)
        
        dealerStackView.addArrangedSubview(dealerTitleLabel)
        dealerStackView.addSpacer()
        dealerStackView.addArrangedSubview(dealerSwitch)
        
        whatsAppStackView.addArrangedSubview(whatsAppTitleLabel)
        whatsAppStackView.addSpacer()
        whatsAppStackView.addArrangedSubview(whatsAppSwitch)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
            $0.width.equalTo(snp.width)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        userAvatarImageView.snp.makeConstraints { $0.width.height.equalTo(Constant.avatarHeight) }
        logoutButton.snp.makeConstraints { $0.height.equalTo(Constant.logoutButtonHeight) }
        phoneTextFieldStackView.snp.makeConstraints { $0.height.equalTo(Constant.phoneTextFieldStackViewHeight) }
        editImageView.snp.makeConstraints { $0.height.width.equalTo(Constant.editImageHeight) }
        
        editUserStackView.addSubview(editAvatarButton)
    
        editAvatarButton.snp.makeConstraints {
            $0.trailing.equalTo(editUserStackView.snp.trailing).inset(Constant.standartConstraint)
            $0.top.equalTo(editUserStackView.snp.top).offset(Constant.standartConstraint)
            $0.height.width.equalTo(Constant.editAvatarButtonHeight)
        }
    }
    
    func setupAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.phoneTextFieldFirstResp))
        phoneTextFieldStackView.addGestureRecognizer(gesture)
    }
    
    @objc
    func phoneTextFieldFirstResp(sender : UITapGestureRecognizer) {
        phoneTextField.becomeFirstResponder()
    }
}

// MARK: - View constants
private enum Constant {
    static let containerStackViewMargins: UIEdgeInsets = .init(top: 16, left: 16, bottom: .zero, right: 16)
    static let avatarHeight: CGFloat = 120
    static let standartConstraint: CGFloat = 16
    static let stackViewInset: CGFloat = 8
    static let stackViewSpacing: CGFloat = 8
    static let userAvatarImageViewRadius: CGFloat = 60
    static let userAvatarBorderWidth: CGFloat = 0.3
    static let logoutButtonHeight: CGFloat = 47
    static let editImageHeight: CGFloat = 20
    static let containerStackViewSpacing: CGFloat = 32
    static let phoneTextFieldStackViewHeight: CGFloat = 40
    static let editAvatarButtonHeight: CGFloat = 24
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 1
    static let additionalInfoStackViewSpacing: CGFloat = 8
    static let additionalInfoStackViewTopInset: CGFloat = 12
    static let titleLabelsFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 14)
    static let additionalLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 13)
}
