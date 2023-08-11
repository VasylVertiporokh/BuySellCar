//
//  ModelConfigurableView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 01/08/2023.
//

import Foundation

protocol ModelConfigurableView {
    associatedtype Model
    func configure(model: Model)
}
