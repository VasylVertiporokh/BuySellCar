//
//  UIResponder+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 22.03.2023.
//

import UIKit
import Combine

extension UIResponder {
    var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: Self.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[Self.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            
            NotificationCenter.default
                .publisher(for: Self.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        ).eraseToAnyPublisher()
    }
}
