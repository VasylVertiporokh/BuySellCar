//
//  FilteredCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 03.04.2023.
//

import Foundation
import UIKit
import SnapKit

final class FilteredCell: UICollectionViewCell {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let filterParamLabel = UILabel()
    private let deleteParamButton = UIButton(type: .system)
    
    // MARK: - Internal properties
    var deleteItem: (() -> Void)?
    
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
extension FilteredCell {
    func setFilteredParam(_ parameter: SearchParam) {
        filterParamLabel.text = parameter.key.keyDescription + " " + parameter.value.searchValueDescription
    }
}

// MARK: - Private extension
private extension FilteredCell {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        
        containerStackView.axis = .horizontal
        containerStackView.spacing = Constants.defaultSpacing
        containerStackView.alignment = .center
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constants.containerStackViewMargins
        
        
        containerStackView.addArrangedSubview(filterParamLabel)
        containerStackView.addArrangedSubview(deleteParamButton)
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(Constants.defaultSpacing)
            $0.bottom.equalTo(contentView.snp.bottom).inset(Constants.defaultSpacing)
            $0.leading.equalTo(contentView.snp.leading).offset(Constants.defaultSpacing)
            $0.trailing.equalTo(contentView.snp.trailing).inset(Constants.defaultSpacing)
        }
        deleteParamButton.snp.makeConstraints { $0.height.width.equalTo(Constants.deleteParamButtonHeight) }
    }
    
    func setupUI() {
        containerStackView.layer.borderColor = Colors.buttonDarkGray.color.cgColor
        containerStackView.layer.borderWidth = Constants.containerStackViewBorderWidth
        containerStackView.layer.cornerRadius = Constants.containerStackViewCornerRadius
        filterParamLabel.textAlignment = .left
        filterParamLabel.font = Constants.filterParamLabelFont
        deleteParamButton.setImage(Assets.closeCircleIcon.image.withRenderingMode(.alwaysOriginal), for: .normal)
        deleteParamButton.addTarget(self, action: #selector(deleteButtonDidTapped), for: .touchUpInside)
    }
}

// MARK: - Action
private extension FilteredCell {
    @objc
    func deleteButtonDidTapped() {
        deleteItem?()
    }
}

// MARK: - Constant
private enum Constants {
    static let defaultSpacing: CGFloat = 8
    static let containerStackViewMargins: UIEdgeInsets = .init(top: .zero, left: 8, bottom: .zero, right: 8)
    static let containerStackViewBorderWidth: CGFloat = 0.5
    static let containerStackViewCornerRadius: CGFloat = 17
    static let filterParamLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 12)
    static let deleteParamButtonHeight: CGFloat = 20
}
