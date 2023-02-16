//
//  AppContainer.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Foundation
import CombineNetworking

protocol AppContainer: AnyObject {
    var appConfiguration: AppConfiguration { get }
    var userService: UserService { get }
    var appSettingsService: AppSettingsService { get }
}

final class AppContainerImpl: AppContainer {
    let appConfiguration: AppConfiguration
    let userService: UserService
    let appSettingsService: AppSettingsService

    init() {
        let appConfiguration = AppConfigurationImpl()
        self.appConfiguration = appConfiguration

        let userService = UserServiceImpl(configuration: appConfiguration)
        self.userService = userService

        let appSettingsService = AppSettingsServiceImpl()
        self.appSettingsService = appSettingsService
    }
}
