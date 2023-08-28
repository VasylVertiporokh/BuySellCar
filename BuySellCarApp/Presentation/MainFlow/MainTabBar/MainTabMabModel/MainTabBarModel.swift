//
//  MainTabBarModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/08/2023.
//

import Foundation
import Combine

protocol MainTabBarModel {
    var numberOfFavorite: AnyPublisher<Int, Never> { get }
    var numberOfOwnAds: AnyPublisher<Int, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    func loadObjectsCount()
}

final class MainTabMabModelImpl {
    // MARK: - Private properties
    private let userService: UserService
    private let adsService: AdvertisementService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Publishers
    var numberOfFavorite: AnyPublisher<Int, Never> {
        userService.numberOfFavoriteAdsPublisher
    }
    
    var numberOfOwnAds: AnyPublisher<Int, Never> {
        adsService.numberOfOwnAdsPublisher
    }
    
    // MARK: - Error publishers
    private(set) lazy var errorPublisher = errorSubject.eraseToAnyPublisher()
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    // MARK: - Init
    init(userService: UserService, adsService: AdvertisementService) {
        self.userService = userService
        self.adsService = adsService
    }
}

// MARK: - MainTabMabModel protocol
extension MainTabMabModelImpl: MainTabBarModel {
    func loadObjectsCount() {
        guard let id = userService.user?.ownerID else {
            return
        }
        
        userService.getFavoriteAds()
            .mapError { $0 as Error }
            .combineLatest(adsService.getOwnAds(byID: id))
            .sink {  [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.errorSubject.send(error)
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
