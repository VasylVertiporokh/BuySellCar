//
//  BaseHeadersPlugin.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 10/10/2023.
//

import Foundation

struct BaseHeadersPlugin {
    // MARK: - Internal properties
    private(set) var token: String?
    
    // MARK: - Init
    init(token: String?) {
        self.token = token
    }
}

// MARK: - NetworkPlugin
extension BaseHeadersPlugin: NetworkPlugin {
    
    func modifyRequest(_ request: inout URLRequest) {
        request.setValue(token, forHTTPHeaderField: "user-token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
