//
//  SearchableModelProtocol.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/07/2023.
//

import Foundation

protocol SearchableModelProtocol {
    var searchParam: SearchParam { get }
    var isSelected: Bool { get set }
}
