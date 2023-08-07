//
//  DetailsView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 01/08/2023.
//

import UIKit
import SnapKit
import Combine
import GoogleMobileAds

enum DetailsViewAction {
    
}

final class DetailsView: BaseView {
    // MARK: - Subviews
    private let scrollView = UIScrollView()
    private let containerStackView = UIStackView()
    private let adsImagesView = AdsImagesView()
    private let priceLocationView = PriceLocationView()
    private let basicDetailsView = BasicDetailsView()
    private let socialNetworkView = SocialNetworkView()
    private let adsBannerContainer = UIStackView()
    private let bannerView = GADBannerView()
    private let specsView = SpecsView()
    private let contactButtonStackView = UIStackView()
    private let phoneButton: UIButton = UIButton(type: .system)
    private let emailButton: UIButton = UIButton(type: .system)
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<DetailsViewAction, Never>()
    
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
extension DetailsView: ModelConfigurableView {
    typealias Model = ViewModel
    
    func configure(model: ViewModel) {
        if let imageArray = model.adsDomainModel.images?.carImages?
            .compactMap({ AdsImageRow.adsImageRow($0) }) {
            adsImagesView.setupSnapshot(
                sections: [ .init(section: .adsImageSection, items: imageArray)]
            )
        }
        socialNetworkView.configure(model: .init(image: Assets.chat.image,
                                                 title: "Chat or video call",
                                                 subtitle: "Contact this dealer using WhatsApp.",
                                                 titleButton: "Go to WhatsApp",
                                                 buttonImage: Assets.whatsAppIcon.image))
        priceLocationView.configure(model: .init(domainModel: model.adsDomainModel))
        basicDetailsView.configure(model: .init(domainModel: model.adsDomainModel))
        specsView.configure(model: .init(domainModel: model.adsDomainModel))
    }
    
    struct ViewModel {
        let adsDomainModel: AdvertisementDomainModel
        
        init(adsDomainModel: AdvertisementDomainModel) {
            self.adsDomainModel = adsDomainModel
        }
    }
}

// MARK: - Internal extension
extension DetailsView {
    func showAds(_ controller: DetailsViewController) {
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2435281174"
        bannerView.rootViewController = controller
        bannerView.load(GADRequest())
    }
}

// MARK: - Private extension
private extension DetailsView {
    func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }
    
    func bindActions() {
        
    }
    
    func setupUI() {
        backgroundColor = .white
        scrollView.contentInset.bottom = Constant.scrollViewBottomInset
        
        phoneButton.setTitle("Call Seller", for: .normal)
        phoneButton.setImage(Assets.phoneIcon.image, for: .normal)
        phoneButton.backgroundColor = Colors.buttonYellow.color
        phoneButton.layer.cornerRadius = Constant.phoneButtonRadius
        phoneButton.centerTextAndImage(spacing: Constant.contactButtonStackViewSpacing)
        phoneButton.tintColor = .black
        phoneButton.titleLabel?.font = Constant.buttonTitleFont
        
        emailButton.setTitle("E-mail", for: .normal)
        emailButton.setImage(Assets.mailIcon.image, for: .normal)
        emailButton.backgroundColor = Colors.buttonYellow.color
        emailButton.layer.cornerRadius = Constant.phoneButtonRadius
        emailButton.centerTextAndImage(spacing: Constant.contactButtonStackViewSpacing)
        emailButton.titleLabel?.font = Constant.buttonTitleFont
        emailButton.tintColor = .black
    }
    
    func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(containerStackView)
        addSubview(contactButtonStackView)
        
        // containerStackView
        containerStackView.axis = .vertical
        containerStackView.addArrangedSubview(adsImagesView)
        containerStackView.addArrangedSubview(priceLocationView)
        containerStackView.addArrangedSubview(basicDetailsView)
        containerStackView.addArrangedSubview(socialNetworkView)
        containerStackView.addArrangedSubview(adsBannerContainer)
        adsBannerContainer.addArrangedSubview(bannerView)
        containerStackView.addArrangedSubview(specsView)
        containerStackView.addSpacer()
        
        // contactButtonStackView
        contactButtonStackView.distribution = .fillEqually
        contactButtonStackView.spacing = Constant.contactButtonStackViewSpacing
        contactButtonStackView.addArrangedSubview(phoneButton)
        contactButtonStackView.addArrangedSubview(emailButton)
        
        // adsBannerContainer
        adsBannerContainer.spacing = Constant.adsBannerContainerSpacing
        adsBannerContainer.axis = .vertical
        adsBannerContainer.isLayoutMarginsRelativeArrangement = true
        adsBannerContainer.layoutMargins = Constant.adsBannerContainerMargins
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
            $0.width.equalTo(snp.width)
        }
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        contactButtonStackView.snp.makeConstraints {
            $0.height.equalTo(Constant.buttonHeight)
            $0.leading.equalTo(snp.leading).offset(Constant.defaultConstaint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.defaultConstaint)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(Constant.buttonStackViewBottomInset)
        }
        
        bannerView.snp.makeConstraints { $0.height.equalTo(Constant.adsBannerContainerHeight) }
        adsImagesView.snp.makeConstraints { $0.height.equalTo(Constant.adsImagesViewHeight) }
    }
}

// MARK: - View constants
private enum Constant {
    static let phoneButtonRadius: CGFloat = 6
    static let buttonTitleFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 14)
    static let buttonStackViewBottomInset: CGFloat = 12
    static let buttonHeight: CGFloat = 47
    static let defaultConstaint: CGFloat = 16
    static let adsImagesViewHeight: CGFloat = 250
    static let adsBannerContainerMargins: UIEdgeInsets = .all(16)
    static let adsBannerContainerHeight: CGFloat = 240
    static let scrollViewBottomInset: CGFloat = 60
    static let adsBannerContainerSpacing: CGFloat = 10
    static let contactButtonStackViewSpacing: CGFloat = 8
}
