//
//  LoaderFooterView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.04.2023.
//

import UIKit
import SnapKit

// MARK: - Footer view
final class LoaderFooterView: UICollectionReusableView {
    // MARK: - Subviews
    private let activityIndicator = UIActivityIndicatorView()
    
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
extension LoaderFooterView {
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.startAnimating()
    }
}

// MARK: - Private extension
private extension LoaderFooterView {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupUI() {
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
    }
    
    func setupLayout() {
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.centerY.equalTo(snp.centerY)
        }
    }
}
