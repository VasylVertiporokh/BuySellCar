//
//  SearchResultViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.03.2023.
//

import Combine
import Foundation

enum SearchResultViewModelEvents {
    case advertisementCount(count: Int)
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
    
    private(set) lazy var filteredSectionPublisher = filteredSectionSubject.eraseToAnyPublisher()
    private let filteredSectionSubject = CurrentValueSubject<[SectionModel<FilteredSection, FilteredRow>], Never>([])
    
    // MARK: - Init
    init(advertisementService: AdvertisementService) {
        self.advertisementService = advertisementService
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        loadAdvertisement()
        loadNumberOfAdvertisements()
        updateSearchParamsDataSource()
    }
    
    override func onViewWillAppear() {
        isLoadingSubject.send(true)
    }
}

// MARK: - Internal extension
extension SearchResultViewModel {
    func deleteSearchParam(_ param: SearchParam) {
        isLoadingSubject.send(true)
        advertisementService.deleteSearchParam(param)
    }
}

// MARK: - Private extension
private extension SearchResultViewModel {
    func loadAdvertisement() {
        advertisementService.advertisementSearchParamsPublisher
            .sink { [unowned self] searchModel in
                advertisementService.searchAdvertisement(
                    searchParams: searchModel.searchParams,
                    pageSize: searchModel.defaultPageSize
                )
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard case let .failure(error) = completion else {
                        return
                    }
                    self?.isLoadingSubject.send(false)
                    self?.errorSubject.send(error)
                } receiveValue: { [weak self] results in
                    guard let self = self else { return }
                    self.isLoadingSubject.send(false)
                    self.updateDataSource(model: results)
                }
                .store(in: &cancellables)
            }
            .store(in: &cancellables)
    }
    
    func loadNumberOfAdvertisements() {
        advertisementService.advertisementCountPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in eventsSubject.send(.advertisementCount(count: $0)) }
            .store(in: &cancellables)
    }
    
    func updateDataSource(model: [AdvertisementResponseModel]) {
        let advertisementSection: SectionModel<AdvertisementSearchResultSection, AdvertisementResultRow> = {
            let items = model.map { AdvertisementResultRow.searchResultRow(model: .init(model: $0)) }
            return .init(section: .searchResult, items: items)
        }()
        sectionsSubject.value = [advertisementSection]
    }
    
    func updateSearchParamsDataSource() {
        advertisementService.advertisementSearchParamsPublisher
            .sink { [unowned self] searchModel in
                let searchSection: SectionModel<FilteredSection, FilteredRow> = {
                    let searchItems = searchModel.searchParams.map { FilteredRow.filteredParameter($0) }
                    return .init(section: .filtered, items: searchItems)
                }()
                self.filteredSectionSubject.value = [searchSection]
            }
            .store(in: &cancellables)
    }
}
