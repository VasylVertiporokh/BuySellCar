//
//  AppContainer.swift
//  MVVMSkeleton
//
//

import Foundation

protocol AppContainer: AnyObject {
    var appConfiguration: AppConfiguration { get }
    var networkManager: NetworkManagerProtocol { get }
    var tokenStorage: TokenStorage { get }
    var appSettingsService: AppSettingsService { get }
    var authNetworkService: AuthNetworkServiceProtocol { get }
    var userDefaultsService: UserDefaultsServiceProtocol { get }
    var userService: UserService { get }
    var userNetworkService: UserNetworkService { get }
    var advertisementNetworkService: AdvertisementNetworkService { get }
    var advertisementService: AdvertisementService { get }
    var addAdvertisementModel: AddAdvertisementModel { get }
    var searchAdvertisementModel: AdvertisementModel { get }
    var emailNetworkService: EmailNetworkService { get }
    var emailService: EmailService { get }
    var coreDataStack: CoreDataStack { get }
    var adsStorageService: AdsStorageService { get }
    var userLocationService: UserLocationService { get }
}

final class AppContainerImpl: AppContainer {
    let appConfiguration: AppConfiguration
    let networkManager: NetworkManagerProtocol
    let tokenStorage: TokenStorage
    let appSettingsService: AppSettingsService
    let authNetworkService: AuthNetworkServiceProtocol
    let userDefaultsService: UserDefaultsServiceProtocol
    let userService: UserService
    let userNetworkService: UserNetworkService
    let advertisementNetworkService: AdvertisementNetworkService
    let advertisementService: AdvertisementService
    let addAdvertisementModel: AddAdvertisementModel
    let searchAdvertisementModel: AdvertisementModel
    let emailNetworkService: EmailNetworkService
    let emailService: EmailService
    let coreDataStack: CoreDataStack = CoreDataStack(dataModelName: .mainModel)
    let adsStorageService: AdsStorageService

    var userLocationService: UserLocationService = {
        return UserLocationServiceImpl()
    }()

    init() {
        // App configuration *API keys and etc.*
        let appConfiguration = AppConfigurationImpl()
        self.appConfiguration = appConfiguration

        // Network manager
        self.networkManager = NetworkManagerImpl()

        // Token storage
        let tokenStorage = TokenStorageImpl(configuration: appConfiguration)
        self.tokenStorage = tokenStorage

        // Base headers
        let baseHeadersPlugin = BaseHeadersPlugin(tokenStorage: tokenStorage)

        // App settings service
        let appSettingsService = AppSettingsServiceImpl()
        self.appSettingsService = appSettingsService

        // User defaults service
        let userDefaultsService = UserDefaultsServiceImpl()
        self.userDefaultsService = userDefaultsService

        // Ads storage service
        self.adsStorageService = AdsStorageServiceImpl(stack: coreDataStack)

        // User network service
        let userNetworkProvider = NetworkServiceProvider<UserEndpointsBuilder>(
            apiInfo: appConfiguration,
            networkManager: networkManager,
            plugins: [baseHeadersPlugin]
        )

        self.userNetworkService = UserNetworkServiceImpl(userNetworkProvider)

        // User service
        let userService = UserServiceImpl(
            tokenStorage: tokenStorage,
            userDefaultsService: userDefaultsService,
            userNetworkService: userNetworkService,
            adsStorageService: adsStorageService
        )
        self.userService = userService

        // Login network service
        let loginNetworkService = NetworkServiceProvider<AuthEndpoitsBuilder>(
            apiInfo: appConfiguration,
            networkManager: networkManager,
            plugins: [baseHeadersPlugin]
        )
        self.authNetworkService = AuthNetworkServiceImpl(loginNetworkService)

        // Advertisement network service
        let advertisementNetworkServiceProvider = NetworkServiceProvider<AdvertisementEndpointBuilder> (
            apiInfo: appConfiguration,
            networkManager: networkManager,
            plugins: [baseHeadersPlugin]
        )

        self.advertisementNetworkService = AdvertisementNetworkImpl(provider: advertisementNetworkServiceProvider)

        // Email network service
        let emailNetworkServiceProvider = NetworkServiceProvider<EmailEndpointsBuilder>(
            apiInfo: appConfiguration,
            networkManager: networkManager,
            plugins: [baseHeadersPlugin]
        )
        self.emailNetworkService = EmailNetworkServiceImpl(emailNetworkServiceProvider)
        self.emailService = EmailServiceImpl(emailNetworkService: emailNetworkService, userService: userService)


        // Ads service
        self.advertisementService = AdvertisementServiceImpl(advertisementNetworkService: advertisementNetworkService)

        // Search ads model
        self.searchAdvertisementModel = AdvertisementModelImpl(advertisementService: advertisementService)

        // Add ads model
        self.addAdvertisementModel = AddAdvertisementModelImpl(
            userService: userService,
            advertisementService: advertisementService,
            userLocationService: userLocationService,
            ownAdsStorageService: adsStorageService
        )
    }
}
