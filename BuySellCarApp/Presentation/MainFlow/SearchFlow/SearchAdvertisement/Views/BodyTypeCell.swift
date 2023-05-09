//
//  BodyTypeCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 19.04.2023.
//

import UIKit
import SnapKit

final class BodyTypeCell: UICollectionViewCell {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let imageContainerStackView = UIStackView()
    private let bodyTypeImageView = UIImageView()
    private let bodyTypeLabel = UILabel()
    
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
extension BodyTypeCell {
    func setData(_ model: BodyTypeCellModel) {
        bodyTypeImageView.image = model.bodyTypeImage
        bodyTypeLabel.text = model.bodyTypeLabel
        containerStackView.backgroundColor = model.isSelected ? Constant.selectedColor : .white
    }
}

// MARK: - Private extension
private extension BodyTypeCell {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins.bottom = Constant.containerStackViewMargins
        
        containerStackView.addArrangedSubview(imageContainerStackView)
        containerStackView.addArrangedSubview(bodyTypeLabel)
        imageContainerStackView.addArrangedSubview(bodyTypeImageView)
    
        containerStackView.axis = .vertical
        imageContainerStackView.alignment = .center
    
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        bodyTypeImageView.snp.makeConstraints { $0.height.equalTo(Constant.bodyTypeImageViewSize) }
        
    }
    
    func setupUI() {
        bodyTypeLabel.numberOfLines = .zero
        bodyTypeLabel.font = Constant.bodyTypeLabelFont
        bodyTypeLabel.textAlignment = .center
        bodyTypeLabel.textColor = Colors.buttonDarkGray.color
        bodyTypeImageView.contentMode = .scaleAspectFit
        containerStackView.layer.cornerRadius = Constant.containerStackViewRadius
    }
}

private enum Constant {
    static let bodyTypeImageViewSize: CGFloat = 30
    static let bodyTypeLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 10)
    static let containerStackViewMargins: CGFloat = 12
    static let containerStackViewRadius: CGFloat = 8
    static let selectedColor: UIColor = .systemBlue.withAlphaComponent(0.5)
}
