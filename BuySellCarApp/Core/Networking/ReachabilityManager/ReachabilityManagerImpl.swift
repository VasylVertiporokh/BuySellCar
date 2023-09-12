//
//  ReachabilityManagerImpl.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 07/09/2023.
//

import Network

// MARK: - App mode
enum AppDataMode {
    case api
    case database
}

final class ReachabilityManagerImpl: ReachabilityManager {
    // MARK: - Static Properties
    private static let queueLabel = "ReachabilityManagerQueue"
    
    // MARK: - Internal Properties
    var isInternetConnectionAvailable = false
    var appMode: AppDataMode = .database
    
    // MARK: - Private Properties
    private var connectionMonitor = NWPathMonitor()
    
    // MARK: - Singleton Init
    public static let shared = ReachabilityManagerImpl()
    
    // MARK: - Private init
    private init() {
        let queue = DispatchQueue(label: ReachabilityManagerImpl.queueLabel)
        self.connectionMonitor.pathUpdateHandler = { pathUpdateHandler in
            self.isInternetConnectionAvailable = pathUpdateHandler.status == .satisfied
            self.appMode = pathUpdateHandler.status == .satisfied ? .api : .database
        }
        self.connectionMonitor.start(queue: queue)
    }
}
