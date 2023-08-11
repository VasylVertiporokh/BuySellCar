//
//  WhatsAppView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 02/08/2023.
//

import UIKit
import Combine
import SnapKit

enum SocialNetworkViewAction {
    case socialNetworkButtonDidTap
}

final class SocialNetworkView: BaseView {
    // MARK: - Subview
    private let containerStackView = UIStackView()
    private let titleStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLable = UILabel()
    private let subtitleLabel = UILabel()
    private let socialButton = UIButton(type: .system)
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SocialNetworkViewAction, Never>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ModelConfigurableView
extension SocialNetworkView: ModelConfigurableView {
    typealias Model = ViewModel
    
    func configure(model: ViewModel) {
        socialButton.setTitle(model.titleButton, for: .normal)
        socialButton.setImage(model.buttonImage, for: .normal)
        socialButton.tintColor = .white
        socialButton.backgroundColor = Colors.whatsAppColor.color
        socialButton.isEnabled = model.isSocialButtonEnable
        imageView.image = model.image
        titleLable.text = model.title
        subtitleLabel.text = model.subtitle
    }
    
    struct ViewModel {
        let image: UIImage
        let title: String
        let subtitle: String
        let titleButton: String
        let buttonImage: UIImage
        let isSocialButtonEnable: Bool
    }
}

// MARK: - Private extenison
private extension SocialNetworkView {
    func initialSetup() {
        setupLayout()
        setupUI()
        bindAction()
    }
    
    func setupLayout() {
        // containerStackView
        addSubview(containerStackView)
        containerStackView.spacing = Constant.defaultSpacing
        containerStackView.axis = .vertical
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewMargins
        containerStackView.addArrangedSubview(titleStackView)
        containerStackView.addArrangedSubview(buttonStackView)
        containerStackView.addSeparator()
        
        // titleStackView
        titleStackView.axis = .horizontal
        titleStackView.spacing = Constant.titleStackViewSpacing
        titleStackView.addArrangedSubview(imageView)
        titleStackView.addArrangedSubview(titleLable)
        
        // buttonStackView
        buttonStackView.axis = .vertical
        buttonStackView.spacing = Constant.defaultSpacing
        buttonStackView.addArrangedSubview(subtitleLabel)
        buttonStackView.addArrangedSubview(socialButton)
        
        imageView.snp.makeConstraints { $0.size.equalTo(Constant.imageViewSize) }
        socialButton.snp.makeConstraints { $0.height.equalTo(Constant.whatsAppButtonHeight) }
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func setupUI() {
        titleLable.font = Constant.titleLabelFont
        subtitleLabel.font = Constant.subtitleLabelFont
        socialButton.titleLabel?.font = Constant.socialButtonFont
        socialButton.centerTextAndImage(spacing: Constant.titleStackViewSpacing)
        socialButton.layer.cornerRadius = Constant.whatsAppButtonRadius
    }
    
    func bindAction() {
        socialButton.tapPublisher
            .sink { [unowned self] in
                actionSubject.send(.socialNetworkButtonDidTap)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Constant
private enum Constant {
    static let defaultSpacing: CGFloat = 16
    static let titleStackViewSpacing: CGFloat = 8
    static let containerStackViewMargins: UIEdgeInsets = .init(top: 10, left: 20, bottom: 8, right: 20)
    static let whatsAppButtonRadius: CGFloat = 6
    static let imageViewSize: CGFloat = 24
    static let whatsAppButtonHeight: CGFloat = 40
    static let titleLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 14)
    static let subtitleLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 12)
    static let socialButtonFont: UIFont = FontFamily.Montserrat.regular.font(size: 14)
}
