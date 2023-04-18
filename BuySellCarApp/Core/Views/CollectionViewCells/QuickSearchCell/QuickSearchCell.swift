//
//  QuickSearchCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 27.03.2023.
//

import UIKit
import SnapKit

final class QuickSearchCell: UICollectionViewCell {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let labelStackView = UIStackView()
    private let carImageView = UIImageView()
    private let descriptionLabel = UILabel()
    
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
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: Constants.shadowPathRadius
        ).cgPath
    }
    
    // MARK: - Override property
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: Constants.duration) {
                self.transform = self.isHighlighted ? Constants.cellAnimation : .identity
            }
        }
    }
}

// MARK: - Internal extension
extension QuickSearchCell {
    func setInfo(_ model: TrendingCategoriesModel) {
        carImageView.image = model.categoriesImage
        descriptionLabel.text = model.categoriesName
    }
}

// MARK: - Private extension
private extension QuickSearchCell {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupUI() {
        setShadow()
        containerStackView.backgroundColor = .clear
        carImageView.contentMode = .scaleAspectFill
        
        carImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        carImageView.layer.cornerRadius = Constants.carImageViewCornerRadius
        carImageView.clipsToBounds = true
        
        descriptionLabel.font = Constants.descriptionLabelFont
        descriptionLabel.numberOfLines = Constants.descriptionLabelLines
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.spacing = Constants.containerStackViewSpacing
        
        containerStackView.addArrangedSubview(carImageView)
        containerStackView.addArrangedSubview(labelStackView)
        
        labelStackView.addArrangedSubview(descriptionLabel)
        labelStackView.alignment = .top
        labelStackView.isLayoutMarginsRelativeArrangement = true
        labelStackView.layoutMargins = Constants.labelStackViewMargins
        
        containerStackView.snp.makeConstraints { $0.edges.equalTo(contentView.snp.edges) }
        carImageView.snp.makeConstraints { $0.height.equalTo(Constants.carImageViewHeight) }
        labelStackView.snp.makeConstraints { $0.height.equalTo(Constants.labelStackViewHeight) }
    }
    
    func setShadow() {
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
}

// MARK: - Constants
private enum Constants {
    static let containerStackViewSpacing: CGFloat = 8
    static let descriptionLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 14)
    static let descriptionLabelLines: Int = 2
    static let carImageViewCornerRadius: CGFloat = 10
    static let carImageViewHeight: CGFloat = 100
    static let labelStackViewHeight: CGFloat = 42
    static let labelStackViewMargins: UIEdgeInsets = .init(top: .zero, left: 16, bottom: .zero, right: 16)
    static let shadowPathRadius: CGFloat = 10
    static let duration: Double = 0.1
    static let cellAnimation: CGAffineTransform = CGAffineTransform(scaleX: 0.9, y: 0.9).concatenating(CGAffineTransform(rotationAngle: -0.10))
}
