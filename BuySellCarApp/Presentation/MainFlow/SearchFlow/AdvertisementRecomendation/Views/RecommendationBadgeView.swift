//
//  RecommendationBadgeView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 27.03.2023.
//

import UIKit
import SnapKit

final class RecommendationBadgeView: UICollectionReusableView {
    // MARK: - Subviews
    private let recommendationLabel = UILabel()
    
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
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = bounds.height / 2
    }
}

// MARK: - Private extension
private extension RecommendationBadgeView {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        addSubview(recommendationLabel)
        recommendationLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(snp.trailing).inset(8)
        }
    }
    
    func setupUI() {
        backgroundColor = Colors.buttonYellow.color
        recommendationLabel.text = "Recommended"
        recommendationLabel.font = FontFamily.Montserrat.regular.font(size: 12)
    }
}
