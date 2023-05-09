//
//  BrandsFooterView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 19.04.2023.
//

import UIKit
import SnapKit

final class BrandsFooterView: UICollectionReusableView {
    // MARK: - Subviews
    private let separatorView = UIView()
    private let showMoreButton = UIButton(type: .system)
    
    // MARK: - Internal properties
    var showMore: (() -> Void)?
    
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
private extension BrandsFooterView {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        backgroundColor = .clear
        addSubview(separatorView)
        addSubview(showMoreButton)
  
        separatorView.snp.makeConstraints {
            $0.height.equalTo(Constants.separatorViewHeight)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(snp.top).offset(Constants.separatorViewTopCostraint)
        }
        
        showMoreButton.snp.makeConstraints {
            $0.trailing.leading.bottom.equalToSuperview()
            $0.top.equalTo(separatorView.snp.bottom)
            $0.height.equalTo(Constants.showMoreButtonHeight)
        }
    }
    
    func setupUI() {
        separatorView.backgroundColor = .lightGray
        showMoreButton.setTitle("Show all makes", for: .normal)
        showMoreButton.titleLabel?.font = Constants.showMoreButtonFont
        showMoreButton.setImage(UIImage(systemName: "plus"), for: .normal)
        showMoreButton.imageEdgeInsets.right = Constants.showMoreButtonImageInsets
        showMoreButton.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
    }
}

// MARK: - Action
private extension BrandsFooterView {
    @objc
    func addButtonDidTapped() {
        showMore?()
    }
}

// MARK: - Constants
private enum Constants {
    static let showMoreButtonHeight: CGFloat = 47
    static let separatorViewHeight: CGFloat = 0.3
    static let titleLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 16)
    static let showMoreButtonImageInsets: CGFloat = 8
    static let showMoreButtonFont: UIFont = FontFamily.Montserrat.regular.font(size: 14)
    static let separatorViewTopCostraint: CGFloat = 16
}
