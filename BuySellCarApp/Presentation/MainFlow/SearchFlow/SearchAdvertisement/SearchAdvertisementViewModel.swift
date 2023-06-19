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
    private var searchDomainModel = FilterDomainModel()
    
    // MARK: - Publisher
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<SearchSection, SearchRow>], Never>([])
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<SearchAdvertisementViewModelEvents, Never>()
        
    // MARK: - Transition publiser
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SearchAdvertisementTransition, Never>()
    
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
        advertisementModel.tempDomainModelPublisher
            .sink { [weak self] model in
                self?.searchDomainModel = model
                self?.updateDataSource()
            }
            .store(in: &cancellables)
        
        advertisementModel.numberOfAdvertisementsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else {
                    return
                }
                self.eventsSubject.send(.numberOfAdvertisements($0))
            }
            .store(in: &cancellables)
    }
    
    func updateDataSource() {
        let basicBrand: [SearchRow] = searchDomainModel.basicBrand.map {  SearchRow.brandsRow($0) }
        let selectedBrand: [SearchRow] = searchDomainModel.selectedBrand.map { SearchRow.selectedBrandRow($0) }
        let bodyTypes: [SearchRow] = searchDomainModel.bodyType.map { SearchRow.bodyTypeRow($0) }
        let fuelTypes: [SearchRow] = searchDomainModel.fuelType.map { SearchRow.fuelTypeRow($0) }
        let transmissionTypes: [SearchRow] = searchDomainModel.transmissionType.map { SearchRow.transmissionTypeRow($0) }
        let yearRange: [SearchRow] = [.firstRegistrationRow(searchDomainModel.year)]
        let milageRange: [SearchRow] = [.millageRow(searchDomainModel.millage)]
        let powerRange: [SearchRow] = [.powerRow(searchDomainModel.power)]
        let isAddingAvailable: Bool = selectedBrand.count < 1
        
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
            .init(section: .bodyType, items: bodyTypes),
            .init(section: .fuelType, items: fuelTypes),
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
    }
    
    func showAllMakes() {
        advertisementModel.getAllBrands()
        transitionSubject.send(.showBrands)
    }
    
    func setYearRange(_ range: TechnicalSpecCellModel.SelectedRange) {
        advertisementModel.rangeValue(range, .registration)
    }
    
    func setMillageRange(_ range: TechnicalSpecCellModel.SelectedRange) {
        advertisementModel.rangeValue(range, .millage)
    }
    
    func setPowerRange(_ range: TechnicalSpecCellModel.SelectedRange) {
        advertisementModel.rangeValue(range, .power)
    }
}

// MARK: - Private extension
private extension SearchAdvertisementViewModel {
    
}
