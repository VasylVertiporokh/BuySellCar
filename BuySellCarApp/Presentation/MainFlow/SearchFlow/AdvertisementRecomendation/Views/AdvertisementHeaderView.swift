//
//  AdvertisementHeaderView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 27.03.2023.
//

import UIKit
import SnapKit

class AdvertisementHeaderView: UICollectionReusableView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let separatorView = UIView()
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
extension AdvertisementHeaderView {
    func setHeaderTitle(_ title: String) {
        titleLabel.text = title
    }
}

// MARK: - Private extension
private extension AdvertisementHeaderView {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        backgroundColor = .clear
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(separatorView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.axis = .vertical
        
        snp.makeConstraints { $0.height.equalTo(Constants.height) }
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        separatorView.snp.makeConstraints { $0.height.equalTo(Constants.separatorViewHeight) }
    }
    
    func setupUI() {
        separatorView.backgroundColor = .lightGray
        titleLabel.textAlignment = .left
        titleLabel.font = Constants.titleLabelFont
    }
}

// MARK: - Constants
private enum Constants {
    static let height: CGFloat = 50
    static let separatorViewHeight: CGFloat = 0.5
    static let titleLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 16)
}
