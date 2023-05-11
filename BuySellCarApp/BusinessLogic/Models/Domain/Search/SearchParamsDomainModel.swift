//
//  SearchResultDomainModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.04.2023.
//

import Foundation

struct SearchParamsDomainModel: Equatable {
    var pageSize: Int = 3
    var offset: Int = 0
    var searchParams: [SearchParam] = []
}
