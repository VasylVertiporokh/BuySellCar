//
//  SearchSectionHeaderView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 19.04.2023.
//

import UIKit
import SnapKit

final class SimpleHeader: UICollectionReusableView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let titleLabel = UILabel()
    
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
extension SimpleHeader {
    func setHeaderTitle(_ title: String) {
        titleLabel.text = title
    }
}

// MARK: - Private extension
private extension SimpleHeader {
    func initialSetup() {
        configureLayout()
        configureUI()
    }
    
    func configureLayout() {
        addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.alignment = .leading
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins.left = Constant.containerStackViewLeadingMargin
        
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(Constant.containerStackViewHeight)
        }
    }
    
    func configureUI() {
        titleLabel.numberOfLines = .zero
        titleLabel.font = Constant.titleLabelFont
        titleLabel.textColor = Colors.buttonDarkGray.color
    }
}

// MARK: - Constant
private enum Constant {
    static let containerStackViewLeadingMargin: CGFloat = 16
    static let containerStackViewHeight: CGFloat = 32
    static let titleLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 12)
}
