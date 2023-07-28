//
//  UICollectionViewLayout+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 19.04.2023.
//

import UIKit

extension UICollectionViewLayout {
    func register<T: UICollectionReusableView>(decoration: T.Type) {
        register(T.self, forDecorationViewOfKind: decoration.className)
    }
}
