//
//  CreatingProgressView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import UIKit
import SnapKit

final class CreatingProgressView: UIView {
    // MARK: - Nested entity
    enum CreatingProgressViewStep {
        case vehicleData
        case createAd
        case creatingInProgress
        case created
    }
    
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let stepLabel = UILabel()
    private let progressAnimationView = AnimationProgressView()
    private let stepDescriptionLabel = UILabel()
    
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
extension CreatingProgressView {
    func configureForStep(_ step: CreatingProgressViewStep) {
        switch step {
        case .createAd:
            stepLabel.text = "Step 1 from 3"
            stepDescriptionLabel.text = "Enter basic data via:"
            progressAnimationView.setupProgress(progress: Constant.firstProgressValue)
            
        case .vehicleData:
            stepLabel.text = "Step 2 from 3"
            stepDescriptionLabel.text = "Complete and check your data"
            progressAnimationView.setupProgress(progress: Constant.secondProgressValue)
            
        case .creatingInProgress:
            stepLabel.text = "In the process of creation"
            stepDescriptionLabel.text = "The ad is being created"
            progressAnimationView.setupProgress(progress: Constant.creatingInProgress)
            
        case .created:
            stepLabel.text = "Finished!"
            stepDescriptionLabel.text = "Congratulations, the ad has been published"
            progressAnimationView.setupProgress(progress: Constant.created)
        }
    }
}

// MARK: - Private extension
private extension CreatingProgressView {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.spacing = Constant.containerStackViewSpacing
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins.right = Constant.defaultMargins
        containerStackView.layoutMargins.left = Constant.defaultMargins
        containerStackView.addArrangedSubview(stepLabel)
        containerStackView.addArrangedSubview(progressAnimationView)
        containerStackView.addArrangedSubview(stepDescriptionLabel)
        
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        progressAnimationView.snp.makeConstraints { $0.height.equalTo(Constant.progressAnimationViewHeight) }
    }
    
    func setupUI() {
        backgroundColor = .systemGroupedBackground
        stepLabel.textColor = .lightGray
        stepLabel.font = Constant.stepLabelFont
        stepDescriptionLabel.textColor = Colors.buttonDarkGray.color
        stepDescriptionLabel.font = Constant.stepDescriptionLabelFont
    }
}

// MARK: - Constant
private enum Constant {
    static let firstProgressValue: Double = 0.3
    static let secondProgressValue: Double = 0.6
    static let creatingInProgress: Double = 0.8
    static let created: Double = 1.0
    static let containerStackViewSpacing: CGFloat = 8
    static let defaultMargins: CGFloat = 16
    static let progressAnimationViewHeight: CGFloat = 8
    static let stepLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 12)
    static let stepDescriptionLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 14)
}
