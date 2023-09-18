//
//  FavoriteViewModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 21/08/2023.
//

import Combine
import Foundation
import SwiftUI

final class FavoriteViewModel: BaseViewModel, ObservableObject {
    // MARK: - Internal properties
    @Published var favoriteModel = [FavoriteCellModel]()
    @Published var loadingState: FavoritesLoadingState = .loaded
    @Published var alert: AlertModel?
    @Published var isLoadingFinished: Bool = false
    
    // MARK: - Private properties
    private let userService: UserService
    private let favoriteStorageService: AdsStorageService
    private var adsDomainModel: [AdvertisementDomainModel]?
    private let reachabilityManager: ReachabilityManager = ReachabilityManagerImpl.shared
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<FavoriteTransition, Never>()
    
    // MARK: - Init
    init(userService: UserService, favoriteStorageService: AdsStorageService) {
        self.userService = userService
        self.favoriteStorageService = favoriteStorageService
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        super.onViewDidLoad()
        fetchAds()
    }
}

// MARK: - Internal extension
extension FavoriteViewModel {
    func deleteFromFavoritListBy(id: String) {
        favoriteModel.removeAll { $0.objectId == id }
        loadingState = .loading
        userService.deleteFromFavorite(objectId: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self,
                      case let .failure(error) = completion else {
                    return
                }
                self.alert = .init(title: Localization.error, message: error.localizedDescription) {
                    self.reloadData()
                }
            } receiveValue: { [weak self] response in
                guard let self = self else {
                    return
                }
                self.adsDomainModel = response.favorite
                    .map { AdvertisementDomainModel(advertisementResponseModel: $0) }
                self.favoriteStorageService.synchronizeAdsByType(.favoriteAds, adsDomainModel: self.adsDomainModel)
                self.setupDataSource()
            }
            .store(in: &cancellables)
    }
    
    func showDetails(id: String) {
        guard let ads = adsDomainModel,
              let selectedAds = ads.first(where: { $0.objectID == id }) else {
            return
        }
        transitionSubject.send(.showDetails(selectedAds))
    }
    
    func reloadData() {
        loadingState = .loading
        getFavorite()
        setupDataSource()
    }
    
    func loadFromDatabase() {
        adsDomainModel = favoriteStorageService.favoriteAds
        setupDataSource()
    }
}

// MARK: - FavoritesLoadingState
extension FavoriteViewModel {
    enum FavoritesLoadingState {
        case loading
        case loaded
        case empty
        case error
    }
}

// MARK: - Private extenison
private extension FavoriteViewModel {
    func fetchAds() {
        switch reachabilityManager.appMode {
        case .api:
            favoriteStorageService.fetchAdsByType(.favoriteAds)
            adsDomainModel = favoriteStorageService.favoriteAds
            setupDataSource()
            getFavorite()
        case .database:
            loadingState = .error
        }
    }
    
    func getFavorite() {
        userService.getFavoriteAds()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self,
                      case .failure(_) = completion else {
                    return
                }
                self.loadingState = .error
            } receiveValue: { [weak self] response in
                guard let self = self else {
                    return
                }
                self.adsDomainModel = response.favorite
                    .map { AdvertisementDomainModel(advertisementResponseModel: $0) }
                self.favoriteStorageService.synchronizeAdsByType(.favoriteAds, adsDomainModel: self.adsDomainModel)
                self.setupDataSource()
                self.isLoadingFinished = true
            }
            .store(in: &cancellables)
    }
    
    func setupDataSource() {
        guard let adsDomainModel = adsDomainModel else {
            return
        }
        
        favoriteModel = adsDomainModel
            .sorted { $0.created > $1.created }
            .map { .init(domainModel: $0) }
        loadingState = favoriteModel.isEmpty ? .empty : .loaded
    }
}
