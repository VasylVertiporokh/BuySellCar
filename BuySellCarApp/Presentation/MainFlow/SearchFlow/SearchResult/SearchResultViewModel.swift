//
//  SearchResultViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.03.2023.
//

import Combine
import Foundation

// MARK: - Model events
enum SearchResultViewModelEvents {
    case advertisementCount(count: Int)
}

final class SearchResultViewModel: BaseViewModel {
    // MARK: - Private properties
    private let advertisementModel: AdvertisementModel
    private var filtersModel = FilterDomainModel()
    private var searchResultModel: [AdvertisementDomainModel] = []
    
    // MARK: - Subjects
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SearchResultTransition, Never>()
    
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<SearchResultViewModelEvents, Never>()
    
    private(set) lazy var sectionPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<AdvertisementSearchResultSection, AdvertisementResultRow>], Never>([])
    
    private(set) lazy var filteredSectionPublisher = filteredSectionSubject.eraseToAnyPublisher()
    private let filteredSectionSubject = CurrentValueSubject<[SectionModel<SelectedFilterSection, SelectedFilterRow>], Never>([])
    
    private(set) lazy var isPagingInProgressPublisher = isPagingInProgressSubject.eraseToAnyPublisher()
    private let isPagingInProgressSubject = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Init
    init(advertisementModel: AdvertisementModel) {
        self.advertisementModel = advertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        setupBindings()
        advertisementModel.searchModelPublisher
            .sink { [weak self] model in
                self?.advertisementModel.getAdvertisementCount(searchParams: model.queryString)
                self?.advertisementModel.findAdvertisements(searchModel: model)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Deinit
    deinit {
        advertisementModel.deleteSearchResult()
    }
}

// MARK: - Internal extension
extension SearchResultViewModel {
    func showSearch() {
        transitionSubject.send(.showSearch)
    }
    
    func loadNextPage(_ startPaging: Bool) {
        advertisementModel.loadNextPage()
        isPagingInProgressSubject.send(true)
    }
    
    func deleteSelectedBrand(_ brand: SelectedBrandModel) {
        advertisementModel.deleteSelectedBrand(brand)
    }
    
    func deleteModel(_ model: ModelCellConfigurationModel) {
        advertisementModel.setModel(model)
    }
    
    func deleteBodyType(_ type: BodyTypeModel) {
        advertisementModel.setBodyType(type)
    }
    
    func deleteFuelType(_ type: FuelTypeModel) {
        advertisementModel.setFuelType(type)
    }
    
    func deleteTransmissionType(_ type: TransmissionTypeModel) {
        advertisementModel.setTransmissionType(type)
    }
    
    func deleteRangeParams(param: SearchParam, type: RangeParametersType) {
        advertisementModel.deleteRangeParams(param: param, type: type)
    }
}

// MARK: - Private extension
private extension SearchResultViewModel {
    func updateSearchResultDataSource() {
        let newItems = searchResultModel.map { AdvertisementResultRow.searchResultRow(model: .init(model: $0)) }
        if sectionsSubject.value.isEmpty {
            self.sectionsSubject.value = [.init(section: .searchResult, items: newItems)]
        } else {
            if let sectionIndex = sectionsSubject.value.firstIndex(where: { $0.section == .searchResult }) {
                let existingItems = sectionsSubject.value[sectionIndex].items
                let uniqueNewItems = newItems.filter { !existingItems.contains($0) }
                sectionsSubject.value[sectionIndex].items.append(contentsOf: uniqueNewItems)
            }
        }
    }
    
    func setupBindings() {
        advertisementModel.modelErrorPublisher
            .sink { [unowned self] in
                errorSubject.send($0)
                isLoadingSubject.send(false)
            }
            .store(in: &cancellables)
        
        advertisementModel.tempDomainModelPublisher
            .sink { [weak self] searchModel in
                guard let self = self else {
                    return
                }
                self.filtersModel = searchModel
                self.updateFitersDataSource()
            }
            .store(in: &cancellables)
        
        advertisementModel.numberOfAdvertisementsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else {
                    return
                }
                self.eventsSubject.send(.advertisementCount(count: $0))
                
            }
            .store(in: &cancellables)
        
        advertisementModel.advertisementPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] advertisement in
                guard let self = self,
                      let advertisement = advertisement else {
                    return
                }
                self.searchResultModel = advertisement
                self.updateSearchResultDataSource()
                self.isLoadingSubject.send(false)
            }
            .store(in: &cancellables)

        advertisementModel.updatingInProgressPublisher
            .sink { [weak self] in
                guard let self = self else {
                    return
                }
                self.sectionsSubject.value = []
                self.isLoadingSubject.send(true)
            }
            .store(in: &cancellables)
    }
    
    func updateFitersDataSource() {
        let selectedBrand: [SelectedFilterRow] = filtersModel.selectedBrand
            .filter { $0.isSelected }
            .map { SelectedFilterRow.selectedBrandRow($0) }
        
        let selectedModel: [SelectedFilterRow] = filtersModel.brandModels
            .filter { $0.isSelected }
            .map { SelectedFilterRow.selectedModelRow($0) }
        
        let selectedBodyTypes: [SelectedFilterRow] = filtersModel.bodyType
            .filter { $0.isSelected }
            .map { SelectedFilterRow.bodyTypeRow($0) }
        
        let selectedFuelType: [SelectedFilterRow] = filtersModel.fuelType
            .filter { $0.isSelected }
            .map { SelectedFilterRow.fuelTypeRow($0) }
        
        let selectedTransmission: [SelectedFilterRow] = filtersModel.transmissionType
            .filter { $0.isSelected }
            .map { SelectedFilterRow.transmissionTypeRow($0) }
        
        let registrationRange: [SelectedFilterRow] = [filtersModel.year.minSearchValue, filtersModel.year.maxSearchValue]
            .compactMap { $0 }
            .map { SelectedFilterRow.firstRegistrationRow($0) }
        
        let millageRange: [SelectedFilterRow] = [filtersModel.millage.minSearchValue, filtersModel.millage.maxSearchValue]
            .compactMap { $0 }
            .map { SelectedFilterRow.millageRow($0) }
        
        let powerRange: [SelectedFilterRow] = [filtersModel.power.minSearchValue, filtersModel.power.maxSearchValue]
            .compactMap { $0 }
            .map { SelectedFilterRow.powerRow($0) }
        
        self.filteredSectionSubject.value = [
            .init(section: .selectedBrand, items: selectedBrand),
            .init(section: .selectedModel, items: selectedModel),
            .init(section: .bodyType, items: selectedBodyTypes),
            .init(section: .fuelType, items: selectedFuelType),
            .init(section: .transmissionType, items: selectedTransmission),
            .init(section: .firstRegistration, items: registrationRange),
            .init(section: .millage, items: millageRange),
            .init(section: .power, items: powerRange)
        ]
    }
}
