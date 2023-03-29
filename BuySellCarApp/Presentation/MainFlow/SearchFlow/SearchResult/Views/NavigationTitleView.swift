//
//  NavigationTitleView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.03.2023.
//

import UIKit
import SnapKit

final class NavigationTitleView: UIView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let numberOfItemsLabel = UILabel()
    private let resultsTitleLabel = UILabel()
    
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
extension NavigationTitleView {
    func setResultCount(_ count: String?) {
        guard let count = count else {
            numberOfItemsLabel.text = "0"
            return
        }
        numberOfItemsLabel.text = count
    }
}

// MARK: - Private extension
private extension NavigationTitleView {
    func initialSetup() {
        setupLayout()
        configureUI()
    }
    
    func setupLayout() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(numberOfItemsLabel)
        containerStackView.addArrangedSubview(resultsTitleLabel)
        
        containerStackView.axis = .vertical
        containerStackView.distribution = .fillEqually
        containerStackView.spacing = 2
        
        containerStackView.snp.makeConstraints { $0.edges.equalTo(snp.edges) }
    }
    
    func configureUI() {
        resultsTitleLabel.text = "Results"
        
        [numberOfItemsLabel, resultsTitleLabel].forEach {
            $0.textAlignment = .center
            $0.font = FontFamily.Montserrat.regular.font(size: 13)
        }
    }
}
