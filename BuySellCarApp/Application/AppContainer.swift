//
//  AppContainer.swift
//  MVVMSkeleton
//
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
    var addAdvertisementModel: AddAdvertisementModel { get }
    var searchAdvertisementModel: AdvertisementModel { get }
    var emailNetworkService: EmailNetworkService { get }
    var emailService: EmailService { get }
    var coreDataStack: CoreDataStack { get }
    var favoriteStorageService: FavoriteAdsStorageService { get }
    var userLocationService: UserLocationService { get }
}

final class AppContainerImpl: AppContainer {
    let appConfiguration: AppConfiguration
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
    let favoriteStorageService: FavoriteAdsStorageService
    var userLocationService: UserLocationService = {
        return UserLocationServiceImpl()
    }()
    
    
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
        // TODO: -  add keychain
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
        
        let emailNetworkServiceProvider = NetworkServiceProvider<EmailEndpointsBuilder>(
            apiInfo: appConfiguration,
            networkManager: networkManager
        )
        self.emailNetworkService = EmailNetworkServiceImpl(emailNetworkServiceProvider)
        self.emailService = EmailServiceImpl(emailNetworkService: emailNetworkService, userService: userService)
        
        self.favoriteStorageService = AdsStorageServiceImpl(stack: coreDataStack)
        
        self.advertisementNetworkService = AdvertisementNetworkImpl(provider: advertisementNetworkServiceProvider)
        self.advertisementService = AdvertisementServiceImpl(advertisementNetworkService: advertisementNetworkService)
        self.searchAdvertisementModel = AdvertisementModelImpl(advertisementService: advertisementService)
        
        self.addAdvertisementModel = AddAdvertisementModelImpl(
            userService: userService,
            advertisementService: advertisementService,
            userLocationService: userLocationService
        )
    }
}
