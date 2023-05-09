//
//  SearchAdvertisementViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.04.2023.
//

import Combine
import Foundation

enum SearchAdvertisementViewModelEvents {
    case updateDataSource
}

final class SearchAdvertisementViewModel: BaseViewModel {
    // MARK: - Private properties
    private let advertisementModel: AdvertisementModel
    
    // MARK: - Publisher
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<SearchSection, SearchRow>], Never>([])
    
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
        
        powerSelectedRangeSubject
            .sink { [unowned self] value in
                print(value)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        updateDataSource()
    }
    
    func updateDataSource() {
        let basicBrand: [SearchRow] = self.basicBrand.compactMap {  SearchRow.brandsRow($0) }
        let selectedBrand: [SearchRow] = self.selectedBrand.compactMap { SearchRow.selectedBrandRow($0) }
        let bodyTypes: [SearchRow] = self.bodyType.compactMap { SearchRow.bodyTypeRow($0) }
        let fuelTypes: [SearchRow] = self.fuelType.compactMap { SearchRow.fuelTypeRow($0) }
        let transmissionTypes: [SearchRow] = self.transmissionType.compactMap { SearchRow.transmissionTypeRow($0) }
        let isAddingAvailable = selectedBrand.count < 3
    
        guard !selectedBrand.isEmpty else {
            sectionsSubject.value = [
                .init(section: .brands, items: basicBrand),
                .init(section: .bodyType, items: bodyTypes), .init(section: .fuelType, items: fuelTypes),
                year, millage, power,
                .init(section: .transmissionType, items: transmissionTypes),
                .init(section: .sellerInfo, items: [.seller("Seller"), .location("Location")])
            ]
            return
        }
        
        sectionsSubject.value = [
            .init(section: .selectedBrand(isAddAvailable: isAddingAvailable), items: selectedBrand),
            .init(section: .bodyType, items: bodyTypes), .init(section: .fuelType, items: fuelTypes),
            year, millage, power,
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
            
        case .selectedBrandRow(let selectedBrandModel):
            print("Open models list")
            
        case .bodyTypeRow(let bodyTypeCellModel):
            guard let index = self.bodyType.firstIndex(of: bodyTypeCellModel) else {
                return
            }
            bodyType[index].isSelected.toggle()
            updateDataSource()
                    
        case .fuelTypeRow(let fuelTypeModel):
            guard let index = self.fuelType.firstIndex(of: fuelTypeModel) else {
                return
            }
            fuelType[index].isSelected.toggle()
            updateDataSource()
            
        case .firstRegistrationRow(let technicalSpecCellModel):
            print(technicalSpecCellModel)
            
        case .millageRow:
            print("millage")
            
        case .powerRow:
            print("power")
            
        case .transmissionTypeRow(let transmissionTypeModel):
            guard let index = self.transmissionType.firstIndex(of: transmissionTypeModel) else {
                return
            }
            transmissionType[index].isSelected.toggle()
            updateDataSource()
            
        case .seller:
            print("Open seller type")
        case .location:
            print("Open seller location")
        }
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
