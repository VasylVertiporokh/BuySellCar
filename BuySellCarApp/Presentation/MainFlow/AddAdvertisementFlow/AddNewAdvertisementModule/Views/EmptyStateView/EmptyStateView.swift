//
//  EmptyStateView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 12.05.2023.
//

import SnapKit
import UIKit

final class EmptyStateView: UIView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let emptyStateImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
// MARK: - Private extension
private extension EmptyStateView {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.alignment = .center
        containerStackView.spacing = Constant.containerStackViewSpacing
        
        containerStackView.addArrangedSubview(emptyStateImageView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(subtitleLabel)
        
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        emptyStateImageView.snp.makeConstraints { $0.size.equalTo(Constant.imageViewSize) }
        
    }
    
    func setupUI() {
        emptyStateImageView.image = Assets.addAdv.image
        emptyStateImageView.contentMode = .scaleAspectFit
        titleLabel.numberOfLines = Constant.numberOfLines
        titleLabel.font = Constant.titleLabelFont
        titleLabel.textAlignment = .center
        titleLabel.text = "Selling a car?\n It's simple." // TODO: - Add to localized
        subtitleLabel.numberOfLines = Constant.numberOfLines
        subtitleLabel.font = Constant.subtitleLabelFont
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Publish your ad today!"
    }
}

// MARK: - Constant
private enum Constant {
    static let containerStackViewSpacing: CGFloat = 16
    static let numberOfLines: Int = 0
    static let titleLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 24)
    static let subtitleLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 12)
    static let imageViewSize: CGFloat = 64
}
