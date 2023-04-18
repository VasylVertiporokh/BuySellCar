//
//  SectionModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 20.03.2023.
//

import Foundation

struct SectionModel<Section: Hashable, Item: Hashable> {
    let section: Section
    var items: [Item]
}
