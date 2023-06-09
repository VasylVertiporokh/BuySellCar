//
//  SelectedBrandCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 24.04.2023.
//

import UIKit
import SnapKit
import Combine

final class SelectedBrandCell: UICollectionViewCell {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let brandInfoStackView = UIStackView()
    private let firstLetterBrandLabel = UILabel()
    private let brandNameLabel = UILabel()
    private let modelLabel = UILabel()
    private let deleteButton = UIButton(type: .system)
    
    // MARK: - Internal properties
    var deleteTapped: (() -> Void)?
    
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
extension SelectedBrandCell {
    func setBrand(_ brandModel: SelectedBrandModel) {
        firstLetterBrandLabel.text = brandModel.brand.first?.uppercased()
        brandNameLabel.text = brandModel.brand
        modelLabel.text = brandModel.model.isEmpty ? Constant.modelLabelDefaultText : brandModel.model.joined(separator: ", ")
    }
}

// MARK: - Private extension
private extension SelectedBrandCell {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.spacing = Constant.containerStackViewSpacing
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewMargins
        containerStackView.addArrangedSubview(firstLetterBrandLabel)
        containerStackView.addArrangedSubview(brandInfoStackView)
        containerStackView.addArrangedSubview(deleteButton)
        
        brandInfoStackView.axis = .vertical
        brandInfoStackView.spacing = Constant.brandInfoStackViewSpacing
        brandInfoStackView.addArrangedSubview(brandNameLabel)
        brandInfoStackView.addArrangedSubview(modelLabel)
        
        containerStackView.snp.makeConstraints { $0.edges.equalTo(contentView.snp.edges) }
        firstLetterBrandLabel.snp.makeConstraints { $0.size.equalTo(Constant.firstLetterBrandLabelSize) }
        deleteButton.snp.makeConstraints { $0.size.equalTo(Constant.deleteButtonSize) }
    }
    
    func setupUI() {
        firstLetterBrandLabel.textAlignment = .center
        firstLetterBrandLabel.font = Constant.firstLetterBrandLabelFont
        
        brandNameLabel.font = Constant.brandNameLabel
        brandNameLabel.textColor = Colors.buttonDarkGray.color
        
        modelLabel.font = Constant.brandNameLabel
        modelLabel.textColor = Constant.modelLabelTextColor
        
        deleteButton.imageEdgeInsets = Constant.deleteButtonImageInsets
        deleteButton.setImage(Assets.closeIcon.image, for: .normal)
        deleteButton.tintColor = Colors.buttonDarkGray.color
        deleteButton.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        
        contentView.layer.borderWidth = Constant.contentViewBorderWidth
        contentView.layer.borderColor = Constant.contentViewBorderColor
    }
}

// MARK: - Action
private extension SelectedBrandCell {
    @objc
    func buttonDidTapped() {
        deleteTapped?()
    }
}

// MARK: - Constant
private enum Constant {
    static let containerStackViewMargins: UIEdgeInsets = .init(top: .zero, left: .zero, bottom: .zero, right: 16)
    static let firstLetterBrandLabelSize: CGFloat = 50
    static let deleteButtonSize: CGFloat = 24
    static let containerStackViewSpacing: CGFloat = 8
    static let brandInfoStackViewSpacing: CGFloat = 2
    static let deleteButtonImageInsets: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    static let contentViewBorderWidth: CGFloat = 0.3
    static let contentViewBorderColor: CGColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    static let firstLetterBrandLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 24)
    static let brandNameLabel: UIFont = FontFamily.Montserrat.regular.font(size: 12)
    static let modelLabelTextColor: UIColor = Colors.buttonDarkGray.color.withAlphaComponent(0.5)
    static let modelLabelDefaultText: String = "All models"
}
