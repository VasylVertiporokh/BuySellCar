//
//  SearchResultCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.03.2023.
//

import UIKit
import SnapKit

final class SearchResultCell: UICollectionViewCell {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let carInformationStackView = UIStackView()
    private let carImageView = UIImageView()
    private let mainInfoStackView = UIStackView()
    private let modelNameStackView = UIStackView()
    private let modelNameLabel = UILabel()
    private let priceLabel = UILabel()
    private let shareButton = UIButton(type: .system)
    private let carDetailsStackView = UIStackView()
    private let leftInfoStackView = UIStackView()
    private let rightInfoStackView = UIStackView()
    private let mileageLabel = UILabel()
    private let powerLabel = UILabel()
    private let numberOfOwners = UILabel()
    private let fuelConsumptionLabel = UILabel()
    private let yearLabel = UILabel()
    private let conditionLabel = UILabel()
    private let fuelTypeLabel = UILabel()
    private let colorLabel = UILabel()
    private let separatorView = UIView()
    private let sellerStackView = UIStackView()
    private let sellerNameLabel = UILabel()
    private let locationLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 8

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8

        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 8
        ).cgPath
    }
}

// MARK: - Internal extension
extension SearchResultCell {
    func setInfo(_ model: AdvertisementCellModel) {
        carImageView.image =  Assets.electric.image
        modelNameLabel.text = "\(model.brandName)"
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
private extension SearchResultCell {
    func initialSetup() {
        configureStackViews()
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(carImageView)
        containerStackView.addArrangedSubview(carInformationStackView)
        carInformationStackView.addArrangedSubview(mainInfoStackView)
        mainInfoStackView.addArrangedSubview(modelNameStackView)
        modelNameStackView.addArrangedSubview(modelNameLabel)
        modelNameStackView.addArrangedSubview(shareButton)
        mainInfoStackView.addArrangedSubview(priceLabel)
        carInformationStackView.addArrangedSubview(carDetailsStackView)
        carDetailsStackView.addArrangedSubview(leftInfoStackView)
        leftInfoStackView.addArrangedSubview(mileageLabel)
        leftInfoStackView.addArrangedSubview(powerLabel)
        leftInfoStackView.addArrangedSubview(numberOfOwners)
        leftInfoStackView.addArrangedSubview(fuelConsumptionLabel)
        carDetailsStackView.addArrangedSubview(rightInfoStackView)
        rightInfoStackView.addArrangedSubview(yearLabel)
        rightInfoStackView.addArrangedSubview(conditionLabel)
        rightInfoStackView.addArrangedSubview(fuelTypeLabel)
        rightInfoStackView.addArrangedSubview(colorLabel)
        carInformationStackView.addArrangedSubview(separatorView)
        carInformationStackView.addArrangedSubview(sellerStackView)
        sellerStackView.addArrangedSubview(sellerNameLabel)
        sellerStackView.addArrangedSubview(locationLabel)
        
        carInformationStackView.isLayoutMarginsRelativeArrangement = true
        carInformationStackView.layoutMargins = .init(top: .zero, left: 16, bottom: 8, right: 16)
        modelNameStackView.isLayoutMarginsRelativeArrangement = true
        modelNameStackView.layoutMargins = .init(top: .zero, left: .zero, bottom: .zero, right: 16)
        
        containerStackView.snp.makeConstraints { $0.edges.equalTo(contentView.snp.edges) }
        carImageView.snp.makeConstraints { $0.height.equalTo(200) }
        shareButton.snp.makeConstraints { $0.height.width.equalTo(25) }
        separatorView.snp.makeConstraints { $0.height.equalTo(0.5) }
    }
    
    func setupUI() {
        configureLabels()
        carImageView.contentMode = .scaleAspectFill
        carImageView.clipsToBounds = true
        carImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        carImageView.layer.cornerRadius = 8
        
        separatorView.backgroundColor = .lightGray
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
    }
}

// MARK: - Configure stack views
private extension SearchResultCell {
    func configureStackViews() {
        containerStackView.axis = .vertical
        containerStackView.spacing = 8
                
        carInformationStackView.axis = .vertical
        carInformationStackView.spacing = 8
        
        mainInfoStackView.axis = .vertical
        mainInfoStackView.distribution = .fill
        mainInfoStackView.spacing = 4
        
        modelNameStackView.axis = .horizontal
        modelNameStackView.alignment = .center
        modelNameStackView.spacing = 32
        
        carDetailsStackView.axis = .horizontal
        carDetailsStackView.spacing = 32
        carDetailsStackView.distribution = .fillEqually
        
        leftInfoStackView.axis = .vertical
        leftInfoStackView.spacing = 6
        leftInfoStackView.distribution = .fillEqually
        
        rightInfoStackView.axis = .vertical
        rightInfoStackView.spacing = 6
        rightInfoStackView.distribution = .fillEqually
        
        sellerStackView.axis = .vertical
        sellerStackView.spacing = 4
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
            $0.font = FontFamily.Montserrat.regular.font(size: 14)
        }
        priceLabel.font = FontFamily.Montserrat.semiBold.font(size: 20)
        modelNameLabel.font = FontFamily.Montserrat.semiBold.font(size: 16)
        modelNameLabel.numberOfLines = 2
    }
}
