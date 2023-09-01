//
//  AdvertisementRecomendationViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.03.2023.
//

import Combine
import Foundation

enum AdvertisementRecommendationViewEvents {
    case hideSkeleton
}

final class AdvertisementRecommendationViewModel: BaseViewModel {
    // MARK: - Private properties
    private let advertisementModel: AdvertisementModel
    private var recommendationDomainModel: RecommendationDomainModel?
    
    // MARK: - Subjects
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdvertisementRecomendationTransition, Never>()
    
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<AdvertisementSection, AdvertisementRow>], Never>([])
    
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<AdvertisementRecommendationViewEvents, Never>()
    
    // MARK: - Init
    init(advertisementModel: AdvertisementModel) {
        self.advertisementModel = advertisementModel
        super.init()
    }
        
    // MARK: - Life cycle
    override func onViewWillAppear() {
        setupBindings()
        advertisementModel.getRecommendedAdvertisements()
    }
}

// MARK: - Internal extension
extension AdvertisementRecommendationViewModel {
    func startSearch() {
        transitionSubject.send(.startSearch(advertisementModel))
    }
    
    func showSelected(_ row: AdvertisementRow) {
        switch row {
        case .recommended(let model):
            let recommendationAds = recommendationDomainModel?.recommendationAds
            guard let ads = recommendationAds?.first(where: { $0.objectID == model.objectID }) else {
                return
            }
            transitionSubject.send(.showDetails(ads))
        case .trending(let model):
            advertisementModel.setFastSearсhParamsById(model.id)
            transitionSubject.send(.showResult(advertisementModel))
        }
    }
}

// MARK: - Private extension
private extension AdvertisementRecommendationViewModel {
    func setupBindings() {
        advertisementModel.recommendationPublisher
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.errorSubject.send(error)
            } receiveValue: { [weak self] advertisementDomainModel in
                guard let self = self else { return }
                self.recommendationDomainModel = advertisementDomainModel
                self.updateDataSource(model: advertisementDomainModel)
            }
            .store(in: &cancellables)
        
        advertisementModel.modelErrorPublisher
            .sink { [weak self] error in
                guard let self = self else {
                    return
                }
                self.errorSubject.send(error)
            }
            .store(in: &cancellables)
    }
    
    func updateDataSource(model: RecommendationDomainModel) {
        let recommended = model.recommendationAds.map { AdvertisementRow.recommended(model: .init(model: $0)) }
        let trending = model.trendingCategories.map {
            AdvertisementRow.trending(model: .init(
                id: $0.id,
                categoriesImage: URL(string: $0.categoryImageURL),
                categoriesName: $0.categoryTitle)
            )
        }
        eventsSubject.send(.hideSkeleton)
        sectionsSubject.value = [
            .init(section: .recommended, items: recommended),
            .init(section: .trendingCategories, items: trending)
        ]
    }
}
