//
//  BrandCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.04.2023.
//

import UIKit
import SnapKit

final class BrandCell: UICollectionViewCell {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let imageContainerStackView = UIStackView()
    private let brandImageView = UIImageView()
    private let brandNameLabel = UILabel()
    
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
extension BrandCell {
    func setData(_ model: BrandCellModel) {
        brandImageView.image = model.logoImage
        brandNameLabel.text = model.brandName
    }
}

// MARK: - Private extension
private extension BrandCell {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(imageContainerStackView)
        containerStackView.addArrangedSubview(brandNameLabel)
        imageContainerStackView.addArrangedSubview(brandImageView)
    
        containerStackView.axis = .vertical
        imageContainerStackView.alignment = .center
    
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        brandImageView.snp.makeConstraints { $0.height.equalTo(Constant.brandImageViewSize) }
        
    }
    
    func setupUI() {
        brandNameLabel.font = Constant.brandNameLabelFont
        brandNameLabel.textAlignment = .center
        brandNameLabel.textColor = Colors.buttonDarkGray.color
        brandImageView.contentMode = .scaleAspectFit
    }
}

private enum Constant {
    static let brandImageViewSize: CGFloat = 30
    static let brandNameLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 12)
}
