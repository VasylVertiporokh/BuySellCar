//
//  NetworkPlugin.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 10/10/2023.
//

import Foundation

protocol NetworkPlugin {
    func modifyRequest(_ request: inout URLRequest)
}
