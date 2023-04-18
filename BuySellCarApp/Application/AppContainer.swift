//
//  AppContainer.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Foundation

protocol AppContainer: AnyObject {
    var appConfiguration: AppConfiguration { get }
    var tokenStorage: TokenStorage { get }
    var appSettingsService: AppSettingsService { get }
    var authNetworkService: AuthNetworkServiceProtocol { get }
    var userDefaultsService: UserDefaultsServiceProtocol { get }
    var userService: UserService { get }
    var userNetworkService: UserNetworkService { get }
    var advertisementNetworkService: AdvertisementNetworkService { get }
    var advertisementService: AdvertisementService { get }
}

final class AppContainerImpl: AppContainer {
    // TODO: - Change to lazy var
    let appConfiguration: AppConfiguration
    let tokenStorage: TokenStorage
    let appSettingsService: AppSettingsService
    let authNetworkService: AuthNetworkServiceProtocol
    let userDefaultsService: UserDefaultsServiceProtocol
    let userService: UserService
    let userNetworkService: UserNetworkService
    let advertisementNetworkService: AdvertisementNetworkService
    let advertisementService: AdvertisementService
    
    init() {
        let appConfiguration = AppConfigurationImpl()
        self.appConfiguration = appConfiguration
        
        let networkManager = NetworkManagerImpl()
        
        let tokenStorage = TokenStorageImpl(configuration: appConfiguration)
        self.tokenStorage = tokenStorage
        
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
            tokenStorage: tokenStorage,
            userDefaultsService: userDefaultsService,
            userNetworkService: userNetworkService)
        self.userService = userService
        
        let loginNetworkService = NetworkServiceProvider<AuthEndpoitsBuilder>(
            apiInfo: appConfiguration,
            networkManager: networkManager
        )
        self.authNetworkService = AuthNetworkServiceImpl(loginNetworkService)
        
        
        let advertisementNetworkServiceProvider = NetworkServiceProvider<AdvertisementEndpointBuilder> (
            apiInfo: appConfiguration,
            networkManager: networkManager
        )
        self.advertisementNetworkService = AdvertisementNetworkImpl(provider: advertisementNetworkServiceProvider)
        
        self.advertisementService = AdvertisementServiceImpl(advertisementNetworkService: advertisementNetworkService)
    }
}
