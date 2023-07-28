//
//  DecorationGroupView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 19.04.2023.
//

import UIKit

final class DecorationGroupView: UICollectionReusableView {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DecorationGroupView {
    func configureUI() {
        backgroundColor = .white
    }
}
