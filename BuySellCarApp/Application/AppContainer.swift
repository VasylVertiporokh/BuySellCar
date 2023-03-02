//
//  AppContainer.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Foundation

protocol AppContainer: AnyObject {
    var appConfiguration: AppConfiguration { get }
    var keychainService: KeychainService { get }
    var appSettingsService: AppSettingsService { get }
    var aurhNetworkService: AuthNetworkServiceProtocol { get }
    var userDefaultsService: UserDefaultsServiceProtocol { get }
    var userService: UserService { get }
    var userNetworkService: UserNetworkService { get }
}

final class AppContainerImpl: AppContainer {
    let appConfiguration: AppConfiguration
    let keychainService: KeychainService
    let appSettingsService: AppSettingsService
    let aurhNetworkService: AuthNetworkServiceProtocol
    let userDefaultsService: UserDefaultsServiceProtocol
    let userService: UserService
    let userNetworkService: UserNetworkService
    
    init() {
        let appConfiguration = AppConfigurationImpl()
        self.appConfiguration = appConfiguration
        
        let networkManager = NetworkManagerImpl()
        
        let keychainService = KeychainServiceImpl(configuration: appConfiguration)
        self.keychainService = keychainService
        
        let appSettingsService = AppSettingsServiceImpl()
        self.appSettingsService = appSettingsService
        
        let userDefaultsService = UserDefaultsServiceImpl()
        self.userDefaultsService = userDefaultsService
        
        let userNetworkProvider = NetworkServiceProvider<UserEndpointsBuilder>(
            apiInfo: appConfiguration,
            networkManager: networkManager
        )
        self.userNetworkService = UserNetworkServiceImpl(userNetworkProvider)
        
        let userService = UserServiceImpl(
            keychainService: keychainService,
            userDefaultsService: userDefaultsService,
            userNetworkService: userNetworkService)
        self.userService = userService
        
        let loginNetworkService = NetworkServiceProvider<AuthEndpoitsBuilder>(
            apiInfo: appConfiguration,
            networkManager: networkManager
        )
        self.aurhNetworkService = AuthNetworkServiceImpl(loginNetworkService)
    }
}
