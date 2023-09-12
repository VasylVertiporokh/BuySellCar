//
//  ReachabilityManager.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 07/09/2023.
//

import Foundation

protocol ReachabilityManager: AnyObject {
    var isInternetConnectionAvailable: Bool { get }
    var appMode: AppDataMode { get }
}
