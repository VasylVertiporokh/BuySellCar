//
//  UserAdsCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 12.05.2023.
//

import UIKit
import SnapKit
import Kingfisher
import Combine

final class UserAdsCell: UICollectionViewCell {
    // MARK: - Action
    enum UserAdsCellAction {
        case deleteAd
    }
    
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let mainInfoStackView = UIStackView()
    private let infoParamStackView = UIStackView()
    private let paramStackView = UIStackView()
    private let deleteButton = UIButton(type: .system)
    private let previewImageView = UIImageView()
    private let brandLabel = UILabel()
    private let brandNameLabel = UILabel()
    private let priceLabel = UILabel()
    private let fixedPriceLabel = UILabel()
    private let yearLabel = UILabel()
    private let productionYearLabel = UILabel()
    
    // MARK: - Internal properties
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<UserAdsCellAction, Never>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        setShadow()
    }
    
    // MARK: - Prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables = .init()
    }
}

// MARK: - Internal extension
extension UserAdsCell {
    func configureCell(with model: AdvertisementCellModel) {
        previewImageView.kf.setImage(with: URL(string: model.imageArray.first ?? ""), placeholder: Assets.carPlaceholder.image)
        brandNameLabel.text = "\(model.brandName) \(model.brandModel)"
        productionYearLabel.text = "\(model.year)"
        fixedPriceLabel.text = "\(model.price)€"
    }
}

// MARK: - Private extension
private extension UserAdsCell {
    func initialSetup() {
        configureStackViews()
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.addSubview(deleteButton)
        containerStackView.snp.makeConstraints { $0.edges.equalTo(contentView) }
        previewImageView.snp.makeConstraints { $0.height.equalTo(Constant.previewImageViewHeight) }
        deleteButton.snp.makeConstraints {
            $0.size.equalTo(Constant.deleteButtonSize)
            $0.trailing.equalTo(containerStackView.snp.trailing).inset(Constant.deleteButtonConstraint)
            $0.bottom.equalTo(containerStackView.snp.bottom).inset(Constant.deleteButtonConstraint)
        }
        configureStackViews()
    }
    
    func setupUI() {
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        previewImageView.layer.cornerRadius = Constant.previewImageCornerRadius
        previewImageView.clipsToBounds = true
        deleteButton.setImage(Assets.trashIcon.image, for: .normal)
        deleteButton.tintColor = .red
        deleteButton.layer.cornerRadius = Constant.deleteButtonRadius
        deleteButton.layer.borderWidth = Constant.deleteButtonBorderWidth
        deleteButton.layer.borderColor = UIColor.red.cgColor
        brandLabel.text = "Car"
        yearLabel.text = "Year"
        priceLabel.text = "Price"
        
        [brandLabel, yearLabel, priceLabel].forEach {
            $0.font = FontFamily.Montserrat.semiBold.font(size: Constant.defaultFontSize)
            $0.textColor = Colors.buttonDarkGray.color
            
        }
        [brandNameLabel, productionYearLabel, fixedPriceLabel].forEach {
            $0.font = FontFamily.Montserrat.regular.font(size: Constant.defaultFontSize)
            $0.textColor = .lightGray
        }
    }
    
    func configureStackViews() {
        containerStackView.axis = .vertical
        containerStackView.addArrangedSubview(previewImageView)
        containerStackView.addArrangedSubview(mainInfoStackView)
        
        mainInfoStackView.axis = .horizontal
        mainInfoStackView.distribution = .fillEqually
        mainInfoStackView.spacing = Constant.mainInfoStackViewSpacing
        mainInfoStackView.addArrangedSubview(infoParamStackView)
        mainInfoStackView.addArrangedSubview(paramStackView)
        mainInfoStackView.isLayoutMarginsRelativeArrangement = true
        mainInfoStackView.layoutMargins = Constant.mainInfoStackViewMargins
        
        infoParamStackView.axis = .vertical
        infoParamStackView.spacing = Constant.defaultSpacing
        infoParamStackView.distribution = .fillEqually
        infoParamStackView.addArrangedSubview(brandLabel)
        infoParamStackView.addArrangedSubview(yearLabel)
        infoParamStackView.addArrangedSubview(priceLabel)
        
        paramStackView.axis = .vertical
        paramStackView.spacing = Constant.defaultSpacing
        paramStackView.distribution = .fillEqually
        paramStackView.addArrangedSubview(brandNameLabel)
        paramStackView.addArrangedSubview(productionYearLabel)
        paramStackView.addArrangedSubview(fixedPriceLabel)
    }
    
    func setShadow() {
        layer.cornerRadius = Constant.mainCornerRadius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = Constant.shadowOffset
        layer.shadowOpacity = Constant.shadowOpacity
        layer.shadowRadius = Constant.mainCornerRadius
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constant.mainCornerRadius
        
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: Constant.mainCornerRadius
        ).cgPath
    }
    
    func bindActions() {
        deleteButton.tapPublisher
            .map({ UserAdsCellAction.deleteAd })
            .subscribe(actionSubject)
            .store(in: &cancellables)
    }
}

// MARK: - Constant
private enum Constant {
    static let mainInfoStackViewMargins: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    static let mainInfoStackViewSpacing: CGFloat = 8
    static let defaultSpacing: CGFloat = 4
    static let previewImageViewHeight: CGFloat = 180
    static let defaultFontSize: CGFloat = 12
    static let mainCornerRadius: CGFloat = 8
    static let shadowOpacity: Float = 0.5
    static let shadowOffset = CGSize(width: .zero, height: 10)
    static let previewImageCornerRadius: CGFloat = 10
    static let deleteButtonSize: CGFloat = 40
    static let deleteButtonRadius: CGFloat = 20
    static let deleteButtonConstraint: CGFloat = 8
    static let deleteButtonBorderWidth: CGFloat = 0.3
}
