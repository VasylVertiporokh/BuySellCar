//
//  AdditionalSearchParamCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 20.04.2023.
//

import UIKit
import SnapKit


final class AdditionalSearchParamCell: UICollectionViewCell {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let paramLabel = UILabel()
    
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
extension AdditionalSearchParamCell {
    func setFuelType(_ model: FuelTypeModel) {
        paramLabel.text = model.fuelType
        containerStackView.backgroundColor = model.isSelected ? Constant.selectedColor : .white
    }
    
    func setTransmissionType(_ model: TransmissionTypeModel) {
        paramLabel.text = model.transmissionType
        containerStackView.backgroundColor = model.isSelected ? Constant.selectedColor : .white
    }
}

// MARK: - Private extension
private extension AdditionalSearchParamCell {
    func initialSetup() {
        configureLayout()
        configureUI()
    }
    
    func configureLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewMargins
        containerStackView.addArrangedSubview(paramLabel)
    }
    
    func configureUI() {
        containerStackView.layer.cornerRadius = Constant.containerStackViewRadius
        containerStackView.layer.borderColor = UIColor.systemBlue.cgColor
        containerStackView.layer.borderWidth = Constant.borderWidth
        
        paramLabel.textAlignment = .center
        paramLabel.font = Constant.paramLabelFont
        paramLabel.textColor = Colors.buttonDarkGray.color
    }
}

// MARK: - Constant
private enum Constant {
    static let containerStackViewMargins: UIEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
    static let selectedColor: UIColor = .systemBlue.withAlphaComponent(0.5)
    static let containerStackViewRadius: CGFloat = 2
    static let borderWidth: CGFloat = 0.5
    static let paramLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 10)
}
