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
        return dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as! T
    }
    
    func dequeueSupplementaryView<T: UICollectionReusableView>(for indexPath: IndexPath, kind: String) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.className, for: indexPath) as! T
    }
    
    func register<C: UICollectionViewCell>(cellType: C.Type) {
        register(cellType.self, forCellWithReuseIdentifier: cellType.className)
    }
    
    func register<T: UICollectionReusableView>(view: T.Type) {
        register(T.self, forSupplementaryViewOfKind: String(describing: view.self) , withReuseIdentifier: view.className)
    }
    
    func register<T: UICollectionReusableView>(header: T.Type) {
        register(
            T.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: header.className
        )
    }

    func register<T: UICollectionReusableView>(footer: T.Type) {
        register(
            T.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: footer.className
        )
    }
}
