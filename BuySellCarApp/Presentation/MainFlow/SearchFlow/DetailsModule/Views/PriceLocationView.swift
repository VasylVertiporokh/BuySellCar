//
//  AdsMainDetailsView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 01/08/2023.
//

import UIKit
import SnapKit

final class PriceLocationView: BaseView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let infoStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let locationButton = UIButton(type: .system)
    private let separatorView = UIView()
    
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
extension PriceLocationView: ModelConfigurableView {
    // MARK: - Typealias
    typealias Model = ViewModel
    
    // MARK: - Configure from model
    func configure(model: Model) {
        locationButton.setTitle(model.location, for: .normal)
        titleLabel.text = model.brand
        priceLabel.text = model.price
    }
    
    // MARK: - ViewModel
    struct ViewModel {
        var location: String?
        let brand: String
        let price: String
        
        // MARK: - Init
        init(domainModel: AdvertisementDomainModel) {
            self.brand = "\(domainModel.transportName) \(domainModel.transportModel)"
            self.location = domainModel.location
            self.price = "€ \(domainModel.price).-"
        }
    }
}
// MARK: - Private extenison
private extension PriceLocationView {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        // containerStackView
        addSubview(containerStackView)
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewMargins
        containerStackView.spacing = Constant.containerStackViewSpacing
        containerStackView.axis = .vertical
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        containerStackView.addArrangedSubview(infoStackView)
        containerStackView.addArrangedSubview(separatorView)
        
        // infoStackView
        infoStackView.axis = .vertical
        infoStackView.spacing = Constant.mainInfoStackViewSpacing
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(priceLabel)
        infoStackView.addArrangedSubview(buttonStackView)
        
        // buttonStackView
        buttonStackView.axis = .horizontal
        buttonStackView.addArrangedSubview(locationButton)
        buttonStackView.addSpacer()
        
        locationButton.snp.makeConstraints { $0.height.equalTo(Constant.locationButtonHeight) }
        separatorView.snp.makeConstraints { $0.height.equalTo(Constant.separatorViewHeight) }
    }
    
    func setupUI() {
        separatorView.backgroundColor = .lightGray
        [titleLabel, priceLabel].forEach { $0.textColor = .black }
        titleLabel.font = Constant.titleLabelFont
        priceLabel.font = Constant.priceLabelFont
        locationButton.tintColor = Colors.customBlue.color
        locationButton.setImage(Assets.outline.image, for: .normal)
        locationButton.centerTextAndImage(spacing: Constant.locationButtonInset)
        locationButton.imageView?.contentMode = .center
        locationButton.titleLabel?.font = Constant.locationButtonFont
    }
}

// MARK: - Constant
private enum Constant {
    static let containerStackViewMargins: UIEdgeInsets = .init(top: 16, left: 16, bottom: 8, right: 16)
    static let locationButtonFont: UIFont = FontFamily.Montserrat.regular.font(size: 14)
    static let locationButtonInset: CGFloat = 8
    static let titleLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 14)
    static let priceLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 18)
    static let separatorViewHeight: CGFloat = 0.5
    static let locationButtonHeight: CGFloat = 20
    static let mainInfoStackViewSpacing: CGFloat = 6
    static let containerStackViewSpacing: CGFloat = 12
}
