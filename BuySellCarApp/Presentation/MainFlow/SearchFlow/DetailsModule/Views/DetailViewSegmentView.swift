//
//  DetailViewSegmentView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 02/08/2023.
//

import UIKit
import SnapKit

final class DetailViewSegmentView: BaseView {
    // MARK: - Subviews
    private let imageView = UIImageView()
    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subTitleLable = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal extesnion
extension DetailViewSegmentView: ModelConfigurableView {
    typealias Model = ViewModel
    
    func configure(model: ViewModel) {
        imageView.image = model.image
        titleLabel.text = model.title
        subTitleLable.text = model.subTitle
    }
    
    struct ViewModel {
        let image: UIImage
        let title: String
        let subTitle: String
    }
}

// MARK: - Private extenison
private extension DetailViewSegmentView {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        addSubview(imageView)
        addSubview(labelStackView)
    
        labelStackView.axis = .vertical
        labelStackView.spacing = Constant.labelStackViewSpacing
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subTitleLable)
                
        imageView.snp.makeConstraints {
            $0.size.equalTo(Constant.imageSize)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(Constant.labelStackViewLeadingOffset)
            $0.top.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupUI() {
        titleLabel.font = Constant.titleFont
        titleLabel.textColor = .lightGray
        subTitleLable.font = Constant.subtitleFont
        subTitleLable.textColor = .black
    }
}

// MARK: - Constant
private enum Constant {
    static let imageSize: Int = 25
    static let titleFont: UIFont = FontFamily.Montserrat.regular.font(size: 10)
    static let subtitleFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 12)
    static let labelStackViewLeadingOffset: Int = 8
    static let labelStackViewSpacing: CGFloat = 6
}
