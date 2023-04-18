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
    private let advertisementModel: AdvertisementModel
    private var searchModel = SearchResultDomainModel()
    
    // MARK: - Subjects
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SearchResultTransition, Never>()
    
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<SearchResultViewModelEvents, Never>()
    
    private(set) lazy var sectionPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<AdvertisementSearchResultSection, AdvertisementResultRow>], Never>([])
    
    private(set) lazy var filteredSectionPublisher = filteredSectionSubject.eraseToAnyPublisher()
    private let filteredSectionSubject = CurrentValueSubject<[SectionModel<FilteredSection, FilteredRow>], Never>([])
    
    private(set) lazy var isPagingInProgressPublisher = isPagingInProgressSubject.eraseToAnyPublisher()
    private let isPagingInProgressSubject = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Init
    init(advertisementModel: AdvertisementModel) {
        self.advertisementModel = advertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        loadAdvertisement()
        updateSearchParamsDataSource()
    }
    
    override func onViewWillAppear() {
        isLoadingSubject.send(true)
    }
    
    // MARK: - Deinit
    deinit {
        advertisementModel.resetSearchParams()
    }
}

// MARK: - Internal extension
extension SearchResultViewModel {
    func deleteSearchParam(_ param: SearchParam) {
        isLoadingSubject.send(true) // TODO: - fix this (change updating logic)
        searchModel.offset = .zero
        searchModel.searchParams.removeAll(where: { $0 == param })
        sectionsSubject.value = []
        advertisementModel.deleteSearchParam(searchModel)
    }
    
    func loadNextPage(_ startPaging: Bool) {
        advertisementModel.loadNextPage()
        isPagingInProgressSubject.send(true)
    }
}

// MARK: - Private extension
private extension SearchResultViewModel {
    func loadAdvertisement() {
        advertisementModel.advertisementSearchParamsPublisher
            .sink { [weak self] searchModel in
                guard let self = self else {
                    return
                }
                self.searchModel = searchModel
                self.loadNumberOfAdvertisements(searchParams: searchModel.searchParams)
                self.advertisementModel.findAdvertisements(searchModel: searchModel)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        guard case let .failure(error) = completion else {
                            return
                        }
                        self?.isLoadingSubject.send(false)
                        self?.errorSubject.send(error)
                        self?.isPagingInProgressSubject.send(false)
                    } receiveValue: { [weak self] result in
                        guard let self = self else { return }
                        self.isLoadingSubject.send(false)
                        self.updateDataSource(model: result)
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
    
    func loadNumberOfAdvertisements(searchParams: [SearchParam]) {
        advertisementModel.getAdvertisementCount(searchParams: searchParams)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.errorSubject.send(error)
            } receiveValue: { [weak self] count in
                guard let self = self  else { return }
                self.eventsSubject.send(.advertisementCount(count: count))
            }
            .store(in: &cancellables)
    }
    
    func updateDataSource(model: [AdvertisementDomainModel]) {
        let newItems = model.map { AdvertisementResultRow.searchResultRow(model: .init(model: $0)) }
        if sectionsSubject.value.isEmpty {
            self.sectionsSubject.value = [.init(section: .searchResult, items: newItems)]
        } else {
            if let sectionIndex = sectionsSubject.value.firstIndex(where: { $0.section == .searchResult }) {
                sectionsSubject.value[sectionIndex].items.append(contentsOf: newItems)
            }
        }
    }
    
    func updateSearchParamsDataSource() {
        advertisementModel.advertisementSearchParamsPublisher
            .sink { [weak self] searchModel in
                guard let self = self else {
                    return
                }
                let searchSection: SectionModel<FilteredSection, FilteredRow> = {
                    let searchItems = searchModel.searchParams.map { FilteredRow.filteredParameter($0) }
                    return .init(section: .filtered, items: searchItems)
                }()
                self.isPagingInProgressSubject.send(false)
                self.filteredSectionSubject.value = [searchSection]
            }
            .store(in: &cancellables)
    }
}
