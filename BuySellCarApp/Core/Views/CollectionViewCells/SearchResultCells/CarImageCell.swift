//
//  CarImageCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 31.03.2023.
//

import SnapKit
import UIKit
import Kingfisher

final class CarImageCell: UICollectionViewCell {
    // MARK: - Subviews
    private let carImageView = UIImageView()
    
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
extension CarImageCell {
    func setImageURL(_ stringURL: String?) {
        carImageView.kf.setImage(with: URL(string: stringURL ?? ""), placeholder: Assets.carPlaceholder.image)
    }
    
    func setImageFromResources(_ resources: ImageResources) {
        switch resources {
        case .fromData(let data):
            guard let data = data else {
                return
            }
            carImageView.image = UIImage(data: data)
        case .fromAssets:
            break
        case .formRemote(let string):
            carImageView.kf.setImage(with: URL(string: string), placeholder: Assets.carPlaceholder.image)
        }
    }
}

// MARK: - Private extension
private extension CarImageCell {
    func initialSetup() {
        setupLayout()
        configureUI()
    }
    
    func setupLayout() {
        contentView.addSubview(carImageView)
        carImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func configureUI() {
        carImageView.contentMode = .scaleAspectFill
        carImageView.clipsToBounds = true
    }
}
