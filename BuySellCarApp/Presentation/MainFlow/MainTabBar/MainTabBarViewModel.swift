//
//  MainTabBarViewModel.swift
//  MVVMSkeleton
//
//

import Combine
import Foundation

enum MainTabBarViewModelEvent {
    case numberOfFavorite(Int)
    case numberOfOwnAds(Int)
}

final class MainTabBarViewModel: BaseViewModel {
    // MARK: - Private properties
    private let model: MainTabBarModel
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<MainTabBarTransition, Never>()
    
    private(set) lazy var eventPublisher = eventSubject.eraseToAnyPublisher()
    private let eventSubject = PassthroughSubject<MainTabBarViewModelEvent, Never>()
    
    // MARK: - Init
    init(model: MainTabBarModel) {
        self.model = model
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        super.onViewDidLoad()
        model.loadObjectsCount()
        setupBindings()
    }
}

// MARK: - Private extenison
private extension MainTabBarViewModel {
    func setupBindings() {
        model.numberOfFavorite
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] favAdsCount in eventSubject.send(.numberOfFavorite(favAdsCount)) }
            .store(in: &cancellables)
        
        model.numberOfOwnAds
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] ownAdsCount in eventSubject.send(.numberOfOwnAds(ownAdsCount)) }
            .store(in: &cancellables)
        
        model.errorPublisher
            .sink { [unowned self] error in errorSubject.send(error) }
            .store(in: &cancellables)
    }
}
