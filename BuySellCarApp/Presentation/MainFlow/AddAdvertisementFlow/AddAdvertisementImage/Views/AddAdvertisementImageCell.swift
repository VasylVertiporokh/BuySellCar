//
//  AddAdvertisementImageCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.05.2023.
//

import Foundation
import SnapKit
import UIKit

// MARK: - AddAdvertisementImageCell
final class AddAdvertisementImageCell: UICollectionViewCell {
    // MARK: - Subviews
    private let containerView = UIStackView()
    private let carImageView = UIImageView()
    private let fakeButtonViewImage = UIImageView()
    
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
extension AddAdvertisementImageCell {
    func configureCell(with model: AdsPhotoModel) {
        switch model.image {
        case .formRemote(let stringUrl):
            carImageView.kf.setImage(with: URL(string: stringUrl), placeholder: model.photoRacurs.racursPlaceholder.image)
            fakeButtonViewImage.image = Assets.closeCircleIcon.image.withTintColor(.white)
        case .fromAssets(let assets):
            carImageView.image = assets.image
            fakeButtonViewImage.image = Assets.addIcon.image.withTintColor(.white)
        case .fromData(let data):
            guard let data = data else { return }
            carImageView.image = UIImage(data: data)
            fakeButtonViewImage.image = Assets.closeCircleIcon.image.withTintColor(.white)
        }
    }
}

// MARK: - Private extension
private extension AddAdvertisementImageCell {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(carImageView)
        containerView.addSubview(fakeButtonViewImage)
        
        containerView.snp.makeConstraints { $0.edges.equalTo(contentView) }
        carImageView.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).offset(Constant.defaultConstraint)
            $0.trailing.equalTo(containerView.snp.trailing).inset(Constant.defaultConstraint)
            $0.top.equalTo(containerView.snp.top).offset(Constant.defaultConstraint)
            $0.bottom.equalTo(containerView.snp.bottom).inset(Constant.defaultConstraint)
        }
        
        fakeButtonViewImage.snp.makeConstraints {
            $0.size.equalTo(Constant.fakeButtonViewImageSize)
            $0.centerY.equalTo(carImageView.snp.top)
            $0.leading.equalTo(carImageView.snp.leading).offset(Constant.fakeButtonViewImageConstraint)
        }
        
        fakeButtonViewImage.snp.makeConstraints {
            $0.edges.equalTo(fakeButtonViewImage)
        }
    }
    
    func setupUI() {
        carImageView.contentMode = .scaleAspectFit
        carImageView.backgroundColor = .clear
        carImageView.layer.borderColor = UIColor.lightGray.cgColor
        carImageView.layer.borderWidth = Constant.carImageViewBorderWidth
        
        fakeButtonViewImage.backgroundColor = Colors.buttonDarkGray.color
        fakeButtonViewImage.layer.cornerRadius = Constant.fakeButtonViewImageRadius
    }
}

// MARK: - View constant
private enum Constant {
    static let defaultConstraint: CGFloat = 14
    static let fakeButtonViewImageRadius: CGFloat = 13
    static let carImageViewBorderWidth: CGFloat = 0.3
    static let fakeButtonViewImageSize: CGFloat = 26
    static let fakeButtonViewImageConstraint: CGFloat = -13
}
