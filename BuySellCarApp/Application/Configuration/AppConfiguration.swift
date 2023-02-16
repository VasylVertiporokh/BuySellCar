//
//  AppConfiguration.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Foundation

protocol AppConfiguration {
    var bundleId: String { get }
    var environment: AppEnvironment { get }
}

final class AppConfigurationImpl: AppConfiguration {
    // MARK: - Internal properties
    let bundleId: String
    let environment: AppEnvironment

    var baseUrl: URL {
        guard let url = URL(string: apiUrl) else {
            fatalError("Invalid url")
        }
        let fullUrl = url.appendingPathComponent(appId).appendingPathComponent(apiKey)
        return fullUrl
    }
    
    // MARK: - Private properties
    private let apiKey: String
    private let appId: String
    private let apiUrl: String
    
    // MARK: - Init
    init(bundle: Bundle = .main) {
        guard
            let bundleId = bundle.bundleIdentifier,
            let infoDict = bundle.infoDictionary,
            let environmentValue = infoDict[Key.Environment] as? String,
            let apiKey = infoDict[Key.ApiKey] as? String,
            let appId = infoDict[Key.AppId] as? String,
            let apiUrl = infoDict[Key.BaseUrl] as? String,
            let environment = AppEnvironment(rawValue: environmentValue)
        else {
            fatalError("config file error")
        }
        
        self.bundleId = bundleId
        self.environment = environment
        self.apiKey = apiKey
        self.appId = appId
        self.apiUrl = apiUrl

        debugPrint(environment)
        debugPrint(bundleId)
        debugPrint("⚙️ \(baseUrl)")
    }
}

fileprivate enum Key {
    static let Environment: String = "APP_ENVIRONMENT"
    static let ApiKey: String = "API_KEY"
    static let AppId: String = "APP_ID"
    static let BaseUrl: String = "BASE_URL"
}
