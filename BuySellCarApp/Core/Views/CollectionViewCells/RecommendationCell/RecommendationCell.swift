//
//  RecommendationCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.03.2023.
//

import Foundation
import SnapKit
import Kingfisher
import UIKit

final class RecommendationCell: UICollectionViewCell {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let headerStackView = UIStackView()
    private let imageStackView = UIStackView()
    private let priceStackView = UIStackView()
    private let mainInfoStackView = UIStackView()
    private let leftInfoStackView = UIStackView()
    private let rightInfoStackView = UIStackView()
    private let sellerStackView = UIStackView()
    private let separatorView = UIView()
    private let carImageView = UIImageView()
    private let brandNameLabel = UILabel()
    private let priceLabel = UILabel()
    private let mileageLabel = UILabel()
    private let powerLabel = UILabel()
    private let numberOfOwners = UILabel()
    private let fuelConsumptionLabel = UILabel()
    private let yearLabel = UILabel()
    private let conditionLabel = UILabel()
    private let fuelTypeLabel = UILabel()
    private let colorLabel = UILabel()
    private let sellerNameLabel = UILabel()
    private let locationLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
        
        layer.cornerRadius = Constant.mainCornerRadius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = Constant.shadowOffset
        layer.shadowOpacity = Constant.shadowOpacity
        layer.shadowRadius = Constant.mainCornerRadius
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constant.mainCornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: Constant.mainCornerRadius
        ).cgPath
    }
}

// MARK: - Internal extension
extension RecommendationCell {
    func setInfo(model: AdvertisementCellModel) {
        carImageView.kf.setImage(with: URL(string: model.imageArray.first ?? ""), placeholder: Assets.carPlaceholder.image)
        brandNameLabel.text = model.brandName
        priceLabel.text = "€ \(model.price).-"
        mileageLabel.text = "\(model.mileage) km"
        powerLabel.text = "\(model.power) hp"
        numberOfOwners.text = "\(Int.random(in: 1...5))"
        fuelConsumptionLabel.text = "\(model.fuelConsumption) L/100 km (comb)*"
        yearLabel.text = String(model.year)
        conditionLabel.text = model.condition
        fuelTypeLabel.text = model.fuelType
        colorLabel.text = model.color
        sellerNameLabel.text = model.sellerName
        locationLabel.text = model.location
    }
}

// MARK: - Private extension
private extension RecommendationCell {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupUI() {
        configureStackViews()
        configureLabels()
        containerStackView.backgroundColor = .clear
        
        separatorView.backgroundColor = .lightGray
        carImageView.contentMode = .scaleAspectFill
        carImageView.clipsToBounds = true
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(headerStackView)
        containerStackView.addArrangedSubview(mainInfoStackView)
        containerStackView.addArrangedSubview(separatorView)
        containerStackView.addArrangedSubview(sellerStackView)
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewMargins
        
        headerStackView.addArrangedSubview(imageStackView)
        headerStackView.addArrangedSubview(priceStackView)
        
        priceStackView.addArrangedSubview(brandNameLabel)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.distribution = .equalCentering
        priceStackView.isLayoutMarginsRelativeArrangement = true
        priceStackView.layoutMargins = Constant.priceStackViewMargins
        
        mainInfoStackView.addArrangedSubview(leftInfoStackView)
        mainInfoStackView.addArrangedSubview(rightInfoStackView)
        
        imageStackView.addArrangedSubview(carImageView)
        
        leftInfoStackView.addArrangedSubview(mileageLabel)
        leftInfoStackView.addArrangedSubview(powerLabel)
        leftInfoStackView.addArrangedSubview(numberOfOwners)
        leftInfoStackView.addArrangedSubview(fuelConsumptionLabel)
        
        rightInfoStackView.addArrangedSubview(yearLabel)
        rightInfoStackView.addArrangedSubview(conditionLabel)
        rightInfoStackView.addArrangedSubview(fuelTypeLabel)
        rightInfoStackView.addArrangedSubview(colorLabel)
        
        sellerStackView.addArrangedSubview(sellerNameLabel)
        sellerStackView.addArrangedSubview(locationLabel)
        
        containerStackView.snp.makeConstraints { $0.edges.equalTo(contentView.snp.edges) }
        carImageView.snp.makeConstraints { $0.height.equalTo(Constant.carImageViewHeight) }
        carImageView.snp.makeConstraints { $0.width.equalTo(Constant.carImageViewWidth) }
        separatorView.snp.makeConstraints { $0.height.equalTo(Constant.separatorViewHeight) }
    }
}

// MARK: - Configure stack views
private extension RecommendationCell {
    func configureStackViews() {
        containerStackView.axis = .vertical
        containerStackView.spacing = Constant.middleSpacing
        headerStackView.axis = .horizontal
        headerStackView.spacing = Constant.middleSpacing
        imageStackView.axis = .vertical
        
        priceStackView.axis = .vertical
        priceStackView.spacing = Constant.priceStackViewSpacing
        
        mainInfoStackView.axis = .horizontal
        mainInfoStackView.distribution = .fillEqually
        mainInfoStackView.spacing = Constant.mainInfoStackViewSpacing
        
        leftInfoStackView.axis = .vertical
        leftInfoStackView.spacing = Constant.minSpacing
        leftInfoStackView.distribution = .fillEqually
        
        rightInfoStackView.axis = .vertical
        rightInfoStackView.spacing = Constant.minSpacing
        rightInfoStackView.distribution = .fillEqually
        
        sellerStackView.axis = .vertical
        sellerStackView.spacing = Constant.minSpacing
        sellerStackView.distribution = .fillProportionally
    }
    
    func configureLabels() {
        [
            mileageLabel,
            powerLabel,
            numberOfOwners,
            fuelConsumptionLabel,
            yearLabel,
            conditionLabel,
            fuelTypeLabel,
            colorLabel,
            sellerNameLabel,
            locationLabel
        ].forEach {
            $0.textColor = .black
            $0.font = Constant.defaultLabelFont
        }
        
        [brandNameLabel, priceLabel].forEach { $0.font = Constant.priceLabelFont }
        brandNameLabel.numberOfLines = Constant.brandNameLabel
    }
}

// MARK: - Constant
private enum Constant {
    static let carImageViewHeight: CGFloat = 80
    static let carImageViewWidth: CGFloat = 90
    static let containerStackViewMargins: UIEdgeInsets = .init(top: 16, left: 16, bottom: 8, right: 16)
    static let priceStackViewMargins: UIEdgeInsets = .init(top: 4, left: .zero, bottom: 16, right: .zero)
    static let mainCornerRadius: CGFloat = 8
    static let shadowOpacity: Float = 0.5
    static let shadowOffset = CGSize(width: .zero, height: 10)
    static let mainInfoStackViewSpacing: CGFloat = 12
    static let priceStackViewSpacing: CGFloat = 10
    static let middleSpacing: CGFloat = 8
    static let minSpacing: CGFloat = 4
    static let defaultLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 14)
    static let priceLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 15)
    static let brandNameLabel: Int = 2
    static let separatorViewHeight: CGFloat = 0.5
}
