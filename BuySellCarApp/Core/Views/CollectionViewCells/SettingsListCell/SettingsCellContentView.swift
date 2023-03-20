//
//  SettingsCellContentView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 14.03.2023.
//

import Foundation
import UIKit
import SnapKit

final class SettingsCellContentView: UIView, UIContentView {
    // MARK: - Internal properties
    var configuration: UIContentConfiguration {
        get { currentConfiguration }
        set {
            guard let newConfiguration = newValue as? SettingsCellContentConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }
    
    // MARK: - Private properties
    private var currentConfiguration: SettingsCellContentConfiguration!
    
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let cellTitleLabel = UILabel()
    private let cellArrowImage = UIImageView()
    
    // MARK: - Init
    init(configuration: SettingsCellContentConfiguration) {
        super.init(frame: .zero)
        setupLayout()
        setupUI()
        apply(configuration: configuration)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private extension
private extension SettingsCellContentView {
    func setupLayout() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(cellTitleLabel)
        containerStackView.addArrangedSubview(cellArrowImage)

        containerStackView.snp.makeConstraints { $0.edges.equalTo(layoutMarginsGuide.snp.edges) }
        containerStackView.axis = .horizontal
        containerStackView.spacing = 16
        containerStackView.alignment = .center
        containerStackView.distribution = .equalSpacing
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = .init(top: 4, left: 4, bottom: 4, right: 4)
        
        cellArrowImage.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.width.equalTo(8)
        }
    }
    
    func setupUI() {
        cellTitleLabel.numberOfLines = .zero
        cellTitleLabel.font = FontFamily.Montserrat.regular.font(size: 15)
        cellArrowImage.image = Assets.arrow.image
    }
    
    private func apply(configuration: SettingsCellContentConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        currentConfiguration = configuration
        cellTitleLabel.text = configuration.cellTitleLabel
    }
}
