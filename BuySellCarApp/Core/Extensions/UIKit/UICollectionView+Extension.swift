//
//  UICollectionView+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 22.03.2023.
//

import UIKit

// MARK: - UICollectionView extension
extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
    func register<C: UICollectionViewCell>(cellType: C.Type) {
        register(cellType.self, forCellWithReuseIdentifier: String(describing: cellType.self))
    }
}
