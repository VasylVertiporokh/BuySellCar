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
    private let advertisementModel: AdvertisementModel
    
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
    private let basicBrand = BrandCellModel.basicBrands()
    private var bodyType = BodyTypeCellModel.basicBodyTypes()
    private var fuelType = FuelTypeModel.fuelTypes()
    private var transmissionType = TransmissionTypeModel.transmissionTypes()
    private var selectedBrand: [SelectedBrandModel] = []
    private lazy var year = TechnicalSpecCellModel.year(selectedRange: selectedYearRangeSubject)
    private lazy var millage = TechnicalSpecCellModel.millage(selectedRange: millageSelectedRangeSubject)
    private lazy var power = TechnicalSpecCellModel.power(selectedRange: powerSelectedRangeSubject)
        
    // MARK: - Init
    init(advertisementModel: AdvertisementModel) {
        self.advertisementModel = advertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        updateDataSource()
        
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
    }
    
    func updateDataSource() {
        let basicBrand: [SearchRow] = self.basicBrand.compactMap {  SearchRow.brandsRow($0) }
        let selectedBrand: [SearchRow] = self.selectedBrand.compactMap { SearchRow.selectedBrandRow($0) }
        let bodyTypes: [SearchRow] = self.bodyType.compactMap { SearchRow.bodyTypeRow($0) }
        let fuelTypes: [SearchRow] = self.fuelType.compactMap { SearchRow.fuelTypeRow($0) }
        let yearRange: [SearchRow] = self.year.compactMap { SearchRow.firstRegistrationRow($0) }
        let milageRange: [SearchRow] = self.millage.compactMap { SearchRow.millageRow($0) }
        let powerRange: [SearchRow] = self.power.compactMap { SearchRow.powerRow($0) }
        let transmissionTypes: [SearchRow] = self.transmissionType.compactMap { SearchRow.transmissionTypeRow($0) }
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
            selectedBrand.append(.init(brand: brandCellModel.brandName))
            updateDataSource()
            
        case .bodyTypeRow(let bodyTypeCellModel):
            guard let index = self.bodyType.firstIndex(of: bodyTypeCellModel) else { return }
            bodyType[index].isSelected.toggle()
            
            advertisementModel.addSearchParam(
                .init(key: .bodyType, value: .equalToString(stringValue: bodyTypeCellModel.bodyTypeLabel))
            )
            
            updateDataSource()
                    
        case .fuelTypeRow(let fuelTypeModel):
            guard let index = self.fuelType.firstIndex(of: fuelTypeModel) else { return }
            fuelType[index].isSelected.toggle()
            
            advertisementModel.addSearchParam(
                .init(key: .fuelType, value: .equalToString(stringValue: fuelTypeModel.fuelType))
            )
            updateDataSource()
    
        case .transmissionTypeRow(let transmissionTypeModel):
            guard let index = self.transmissionType.firstIndex(of: transmissionTypeModel) else { return }
            transmissionType[index].isSelected.toggle()
            
            advertisementModel.addSearchParam(
                .init(
                    key: .transmissionType, value: .equalToString(stringValue: transmissionTypeModel.transmissionType)
                )
            )
            updateDataSource()
        default:
            break
        }
    }
    
    func showSearchResults() {
        transitionSubject.send(.showResults)
    }
    
    func deleteSelectedBrand(_ brand: SelectedBrandModel) {
        selectedBrand.removeAll { $0 == brand }
        updateDataSource()
    }

    func resetSearch() {
        advertisementModel.resetSearchParams()
        bodyType = BodyTypeCellModel.basicBodyTypes()
        selectedBrand.removeAll()
        fuelType = FuelTypeModel.fuelTypes()
        transmissionType = TransmissionTypeModel.transmissionTypes()
        selectedYearRangeSubject.value = .init()
        millageSelectedRangeSubject.value = .init()
        powerSelectedRangeSubject.value = .init()
        year = TechnicalSpecCellModel.year(selectedRange: selectedYearRangeSubject)
        millage = TechnicalSpecCellModel.millage(selectedRange: millageSelectedRangeSubject)
        power = TechnicalSpecCellModel.power(selectedRange: powerSelectedRangeSubject)
        updateDataSource()
    }
}

// MARK: - Private extension
private extension SearchAdvertisementViewModel {
    
}
