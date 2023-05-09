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
    private let containerStackView = UIStackView()
    private let arrowImageView = UIImageView()
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
        cellLabel.text = labelText
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
        containerStackView.addArrangedSubview(cellLabel)
        containerStackView.addArrangedSubview(arrowImageView)
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewLayoutMargins
        containerStackView.axis = .horizontal
        containerStackView.distribution = .equalSpacing
        containerStackView.alignment = .center
        
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        arrowImageView.snp.makeConstraints {
            $0.height.equalTo(Constant.arrowImageHeight)
            $0.width.equalTo(Constant.arrowImageWidth)
        }
    }
    
    func configureUI() {
        backgroundColor = .white
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
    static let contentViewBorderColor: CGColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    static let arrowImageHeight: CGFloat = 16
    static let arrowImageWidth: CGFloat = 8
    static let cellLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 14)
}
