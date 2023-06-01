//
//  SearchPlainCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 21.04.2023.
//

import SnapKit
import UIKit

final class SearchPlainCell: UICollectionViewCell {
    // MARK: - Subviews
    private let colorIndicatorView = UIView()
    private let containerStackView = UIStackView()
    private let arrowImageView = UIImageView()
    private let checkMarkImageView = UIImageView() //checkMark
    private let cellLabel = UILabel()
    
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
extension SearchPlainCell {
    func setLabelText(_ labelText: String) {
        arrowImageView.isHidden = false
        cellLabel.text = labelText
    }
    
    func setBrand(from model: BrandCellConfigurationModel) {
        cellLabel.text = model.brandName
        checkMarkImageView.isHidden = !model.isSelected
    }
    
    func setModel(from model: ModelCellConfigurationModel) {
        cellLabel.text = model.modelName
    }
    
    func setFuelType(fuelType: FuelType) {
        cellLabel.text = fuelType.rawValue
    }
    
    func setCarColor(color: CarColor) {
        cellLabel.text = color.rawValue
        colorIndicatorView.backgroundColor = color.colors
        colorIndicatorView.isHidden = false
    }
}

// MARK: - Private extension
private extension SearchPlainCell {
    func initialSetup() {
        configureLayout()
        configureUI()
    }
    
    func configureLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(colorIndicatorView)
        containerStackView.addArrangedSubview(cellLabel)
        containerStackView.addSpacer()
        containerStackView.addArrangedSubview(arrowImageView)
        containerStackView.addArrangedSubview(checkMarkImageView)
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewLayoutMargins
        containerStackView.axis = .horizontal
        containerStackView.spacing = Constant.containerStackViewSpacing
        containerStackView.alignment = .center
        
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        colorIndicatorView.snp.makeConstraints { $0.size.equalTo(Constant.colorIndicatorSize) }
        arrowImageView.snp.makeConstraints {
            $0.height.equalTo(Constant.arrowImageHeight)
            $0.width.equalTo(Constant.arrowImageWidth)
        }
        
        checkMarkImageView.snp.makeConstraints { $0.size.equalTo(24) }
    }
    
    func configureUI() {
        backgroundColor = .white
        colorIndicatorView.layer.borderWidth = Constant.colorIndicatorViewBorderWidth
        colorIndicatorView.layer.borderColor = Colors.buttonDarkGray.color.cgColor
        colorIndicatorView.layer.cornerRadius = Constant.colorIndicatorViewRadius
        arrowImageView.isHidden = true
        colorIndicatorView.isHidden = true
        checkMarkImageView.isHidden = true
        checkMarkImageView.image = Assets.checkMark.image
        arrowImageView.image = Assets.arrow.image
        cellLabel.font = Constant.cellLabelFont
        contentView.layer.borderWidth = Constant.contentViewBorderWidth
        contentView.layer.borderColor = Constant.contentViewBorderColor
    }
}

// MARK: - Constant
private enum Constant {
    static let containerStackViewLayoutMargins: UIEdgeInsets = .init(top: .zero, left: 16, bottom: .zero, right: 16)
    static let contentViewBorderWidth: CGFloat = 0.3
    static let containerStackViewSpacing: CGFloat = 16
    static let colorIndicatorSize: CGFloat = 20
    static let colorIndicatorViewRadius: CGFloat = 10
    static let colorIndicatorViewBorderWidth: CGFloat = 0.3
    static let contentViewBorderColor: CGColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    static let arrowImageHeight: CGFloat = 16
    static let arrowImageWidth: CGFloat = 8
    static let cellLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 14)
}
