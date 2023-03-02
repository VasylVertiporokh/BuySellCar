//
//  KeychainService.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Foundation
import KeychainAccess

protocol KeychainService {
    var isAuthorized: Bool { get }
    var token: String? { get }
    
    func saveToken(token: String)
    func clear()
}

final class KeychainServiceImpl: KeychainService {
    // MARK: - Internal properties
    var isAuthorized: Bool {
        keychain[Keys.token] != nil
    }
    
    var token: String? {
        keychain[Keys.token]
    }
    
    // MARK: - Private properties
    private let keychain: Keychain
    private let configuration: AppConfiguration
    
    // MARK: - Init
    init(configuration: AppConfiguration) {
        self.configuration = configuration
        self.keychain = Keychain(service: configuration.bundleId)
    }
    
    func saveToken(token: String) {
        keychain[Keys.token] = token
    }
    
    func clear() {
        keychain[Keys.token] = nil
    }
}
extension KeychainServiceImpl {
    private enum Keys: CaseIterable {
        static let token = "secure_token_key"
    }
}
