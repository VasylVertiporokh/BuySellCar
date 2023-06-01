//
//  SearchAdvertisementViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.04.2023.
//

import Combine
import Foundation

enum SearchAdvertisementViewModelEvents {
    case numberOfAdvertisements(Int)
}

final class SearchAdvertisementViewModel: BaseViewModel {
    // MARK: - Private properties
    private var advertisementModel: AdvertisementModel
    private var searchDomainModel = SearchAdvertismentDomainModel()
    
    // MARK: - Publisher
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<SearchSection, SearchRow>], Never>([])
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<SearchAdvertisementViewModelEvents, Never>()
    
    // MARK: - Subjects
    private let selectedYearRangeSubject = CurrentValueSubject<TechnicalSpecCellModel.SelectedRange, Never>(.init())
    private let millageSelectedRangeSubject = CurrentValueSubject<TechnicalSpecCellModel.SelectedRange, Never>(.init())
    private let powerSelectedRangeSubject = CurrentValueSubject<TechnicalSpecCellModel.SelectedRange, Never>(.init())
    
    // MARK: - Transition publiser
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SearchAdvertisementTransition, Never>()
    
    // MARK: - Sections item
    private lazy var year = TechnicalSpecCellModel.year(selectedRange: selectedYearRangeSubject)
    private lazy var millage = TechnicalSpecCellModel.millage(selectedRange: millageSelectedRangeSubject)
    private lazy var power = TechnicalSpecCellModel.power(selectedRange: powerSelectedRangeSubject)
        
    // MARK: - Init
    init(advertisementModel: AdvertisementModel) {
        self.advertisementModel = advertisementModel
        super.init()
    }
    
    // MARK: - Deinit
    deinit {
        resetSearch()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        millageSelectedRangeSubject
            .dropFirst()
            .removeDuplicates()
            .debounce(for: 2, scheduler: RunLoop.main)
            .sink { [unowned self] value in
                advertisementModel.rangeValue(value, searchKey: .mileage)
            }
            .store(in: &cancellables)
        
        selectedYearRangeSubject
            .dropFirst()
            .removeDuplicates()
            .debounce(for: 2, scheduler: RunLoop.main)
            .sink { [unowned self] value in
                advertisementModel.rangeValue(value, searchKey: .yearOfManufacture)
            }
            .store(in: &cancellables)
        
        powerSelectedRangeSubject
            .dropFirst()
            .removeDuplicates()
            .debounce(for: 2, scheduler: RunLoop.main)
            .sink { [unowned self] value in
                advertisementModel.rangeValue(value, searchKey: .power)
            }
            .store(in: &cancellables)
    
        advertisementModel.advertisementSearchParamsPublisher
            .sink { [weak self] params in
                guard let self = self else { return }
                
                self.advertisementModel.getAdvertisementCount(searchParams: params.searchParams)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        guard let self = self,
                              case let .failure(error) = completion else {
                            return
                        }
                        self.errorSubject.send(error)
                    } receiveValue: { [weak self] count in
                        guard let self = self else { return }
                        self.eventsSubject.send(.numberOfAdvertisements(count))
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
        
        advertisementModel.tempDomainModelPublisher
            .sink { [weak self] model in
                self?.searchDomainModel = model
                self?.updateDataSource()
            }
            .store(in: &cancellables)
    }
    
    func updateDataSource() {
        let basicBrand: [SearchRow] = searchDomainModel.basicBrand.map {  SearchRow.brandsRow($0) }
        let selectedBrand: [SearchRow] = searchDomainModel.selectedBrand.map { SearchRow.selectedBrandRow($0) }
        let bodyTypes: [SearchRow] = searchDomainModel.bodyType.map { SearchRow.bodyTypeRow($0) }
        let fuelTypes: [SearchRow] = searchDomainModel.fuelType.map { SearchRow.fuelTypeRow($0) }
        let transmissionTypes: [SearchRow] = searchDomainModel.transmissionType.map { SearchRow.transmissionTypeRow($0) }
        let yearRange: [SearchRow] = year.map { SearchRow.firstRegistrationRow($0) }
        let milageRange: [SearchRow] = millage.map { SearchRow.millageRow($0) }
        let powerRange: [SearchRow] = power.map { SearchRow.powerRow($0) }
        let isAddingAvailable = selectedBrand.count < 3
        
        guard !selectedBrand.isEmpty else {
            sectionsSubject.value = [
                .init(section: .brands, items: basicBrand),
                .init(section: .bodyType, items: bodyTypes),
                .init(section: .fuelType, items: fuelTypes),
                .init(section: .firstRegistration, items: yearRange),
                .init(section: .millage, items: milageRange),
                .init(section: .power, items: powerRange),
                .init(section: .transmissionType, items: transmissionTypes),
                .init(section: .sellerInfo, items: [.seller("Seller"), .location("Location")])
            ]
            return
        }
        
        sectionsSubject.value = [
            .init(section: .selectedBrand(isAddAvailable: isAddingAvailable), items: selectedBrand),
            .init(section: .bodyType, items: bodyTypes), .init(section: .fuelType, items: fuelTypes),
            .init(section: .firstRegistration, items: yearRange),
            .init(section: .millage, items: milageRange),
            .init(section: .power, items: powerRange),
            .init(section: .transmissionType, items: transmissionTypes),
            .init(section: .sellerInfo, items: [.seller("Seller"), .location("Location")])
        ]
    }
}


// MARK: - Internal extension
extension SearchAdvertisementViewModel {
    func didSelect(_ item: SearchRow) {
        switch item {
        case .brandsRow(let brandCellModel):
            transitionSubject.send(.showModels)
            advertisementModel.getBrandModels(id: brandCellModel.id)
            
        case .selectedBrandRow(let selectedBrandModel):
            transitionSubject.send(.showModels)
            advertisementModel.getBrandModels(id: selectedBrandModel.id)
            
        case .bodyTypeRow(let bodyTypeCellModel):
            advertisementModel.setBodyType(bodyTypeCellModel)
                    
        case .fuelTypeRow(let fuelTypeModel):
            advertisementModel.setFuelType(fuelTypeModel)
    
        case .transmissionTypeRow(let transmissionTypeModel):
            advertisementModel.setTransmissionType(transmissionTypeModel)
            
        default:
            break
        }
    }
    
    func showSearchResults() {
        transitionSubject.send(.showResults)
    }
    
    func deleteSelectedBrand(_ brand: SelectedBrandModel) {
        advertisementModel.deleteSelectedBrand(brand)
    }

    func resetSearch() {
        advertisementModel.resetSearchParams()
        selectedYearRangeSubject.value = .init()
        millageSelectedRangeSubject.value = .init()
        powerSelectedRangeSubject.value = .init()
          
        year = TechnicalSpecCellModel.year(selectedRange: selectedYearRangeSubject)
        millage = TechnicalSpecCellModel.millage(selectedRange: millageSelectedRangeSubject)
        power = TechnicalSpecCellModel.power(selectedRange: powerSelectedRangeSubject)
        updateDataSource()
    }
    
    func showAllMakes() {
        transitionSubject.send(.showBrands)
    }
}

// MARK: - Private extension
private extension SearchAdvertisementViewModel {
    
}
