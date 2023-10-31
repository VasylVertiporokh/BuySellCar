//
//  BaseHeadersPlugin.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 10/10/2023.
//

import Foundation

struct BaseHeadersPlugin {
    // MARK: - Private properties
    private let tokenStorage: TokenStorage
    
    // MARK: - Computed properties
    private var token: String? {
        return tokenStorage.token?.value
    }
    
    // MARK: - Init
    init(tokenStorage: TokenStorage) {
        self.tokenStorage = tokenStorage
    }
}

// MARK: - NetworkPlugin
extension BaseHeadersPlugin: NetworkPlugin {
    
    func modifyRequest(_ request: inout URLRequest) {
        request.setValue(token, forHTTPHeaderField: "user-token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
