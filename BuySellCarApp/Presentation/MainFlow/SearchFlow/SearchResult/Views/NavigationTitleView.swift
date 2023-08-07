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

// MARK: - ModelConfigurableView
extension NavigationTitleView: ModelConfigurableView {
    typealias Model = ViewModel
    
    func configure(model: ViewModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
    
    struct ViewModel {
        var title: String?
        var subtitle: String?
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
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(subtitleLabel)
        
        containerStackView.axis = .vertical
        containerStackView.distribution = .fillEqually
        containerStackView.spacing = 2
        
        containerStackView.snp.makeConstraints { $0.edges.equalTo(snp.edges) }
    }
    
    func configureUI() {
        [titleLabel, subtitleLabel].forEach {
            $0.textAlignment = .center
            $0.font = FontFamily.Montserrat.regular.font(size: 13)
        }
    }
}
