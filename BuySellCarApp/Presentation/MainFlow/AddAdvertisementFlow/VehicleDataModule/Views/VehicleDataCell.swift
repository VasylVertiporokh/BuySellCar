//
//  VehicleDataCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import UIKit
import SnapKit

final class VehicleDataCell: UICollectionViewCell {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let dataInfoStackView = UIStackView()
    private let separatorView = UIView()
    private let dataTypeLabel = UILabel()
    private let dataDetailsLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrided properties
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: Constant.animationDuration) {
                self.transform = self.isHighlighted ? .init(scaleX: Constant.scale, y: Constant.scale) : .identity
            }
        }
    }
}

// MARK: - Internal extension
extension VehicleDataCell {
    func configureCell(from model: VehicleDataCellModel) {
        dataTypeLabel.text = model.dataType.rawValue
        dataDetailsLabel.text = model.dataDescriptionTitle
    }
}

// MARK: - Private extension
private extension VehicleDataCell {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins.left = Constant.defaultMargins
        containerStackView.addArrangedSubview(dataInfoStackView)
        containerStackView.addArrangedSubview(separatorView)
        
        dataInfoStackView.axis = .horizontal
        dataInfoStackView.alignment = .center
        dataInfoStackView.spacing = Constant.dataInfoStackViewSpacing
        dataInfoStackView.isLayoutMarginsRelativeArrangement = true
        dataInfoStackView.layoutMargins.right = Constant.defaultMargins
        
        dataInfoStackView.addArrangedSubview(dataTypeLabel)
        dataInfoStackView.addSpacer()
        dataInfoStackView.addArrangedSubview(dataDetailsLabel)
        dataInfoStackView.addArrangedSubview(arrowImageView)
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
            $0.height.equalTo(Constant.containerStackViewHeight)
        }
        
        separatorView.snp.makeConstraints { $0.height.equalTo(Constant.separatorViewHeight) }
        arrowImageView.snp.makeConstraints {
            $0.height.equalTo(Constant.arrowImageHeight)
            $0.width.equalTo(Constant.arrowImageWidth)
        }

    }
    
    func setupUI() {
        contentView.backgroundColor = .white
        separatorView.backgroundColor = Constant.separatorViewColor
        arrowImageView.image = Assets.arrow.image
        [dataTypeLabel, dataDetailsLabel].forEach {
            $0.font = Constant.labelFont
            $0.textColor = Colors.buttonDarkGray.color
        }
    }
}

// MARK: - Constant
private enum Constant {
    static let dataInfoStackViewSpacing: CGFloat = 16
    static let containerStackViewHeight: CGFloat = 47
    static let defaultMargins: CGFloat = 16
    static let separatorViewHeight: CGFloat = 0.3
    static let arrowImageHeight: CGFloat = 16
    static let arrowImageWidth: CGFloat = 8
    static let animationDuration: Double = 0.1
    static let scale: CGFloat = 0.85
    static let labelFont: UIFont = FontFamily.Montserrat.regular.font(size: 14)
    static let separatorViewColor: UIColor = Colors.buttonDarkGray.color.withAlphaComponent(0.3)
}
