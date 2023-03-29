//
//  SearchResultViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.03.2023.
//

import Combine
import Foundation

enum SearchResultViewModelEvents {
    case advertisementCount(count: String?)
}

final class SearchResultViewModel: BaseViewModel {
    // MARK: - Private properties
    private let advertisementService: AdvertisementService
    
    // MARK: - Subjects
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SearchResultTransition, Never>()
    
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<SearchResultViewModelEvents, Never>()
    
    private(set) lazy var sectionPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<AdvertisementSearchResultSection, AdvertisementResultRow>], Never>([])
    
    // MARK: - Init
    init(advertisementService: AdvertisementService) {
        self.advertisementService = advertisementService
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        advertisementService.getAdvertisementObjects(pageSize: "")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.errorSubject.send(error)
            } receiveValue: { [weak self] searchResult in
                guard let self = self else { return }
                self.updateDataSource(model: searchResult)
            }
            .store(in: &cancellables)
        
        advertisementService.advertisementCountPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in eventsSubject.send(.advertisementCount(count: $0.advertisementCount)) }
            .store(in: &cancellables)
    }
}

// MARK: - Private extension
private extension SearchResultViewModel {
    func updateDataSource(model: [AdvertisementResponseModel]) {
        let userProfileSection: SectionModel<AdvertisementSearchResultSection, AdvertisementResultRow> = {
            let recommendedItems = model.map { AdvertisementResultRow.searchResultRow(model: .init(model: $0)) }
            return .init(section: .searchResult, items: recommendedItems)
        }()
        self.sectionsSubject.value = [userProfileSection]
    }
}
