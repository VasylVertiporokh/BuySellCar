//
//  BrandListViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import Combine
import Foundation

final class BrandListViewModel: BaseViewModel {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<BrandListTransition, Never>()
    
    // MARK: - Section publisher
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<BrandSection, BrandRow>], Never>([])
    
    // MARK: - Subjects
    private let searchTextSubject = CurrentValueSubject<String, Never>("")
    
    // MARK: - Init
    init(addAdvertisementModel: AddAdvertisementModel) {
        self.addAdvertisementModel = addAdvertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        isLoadingSubject.send(true)
        addAdvertisementModel.getBrands()
        searchTextSubject
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .combineLatest(addAdvertisementModel.brandsPublisher)
            .map { (searchText, brands) -> [BrandDomainModel] in
                if searchText.isEmpty {
                    return brands
                }
                return brands.filter { $0.name.hasPrefix(searchText) }
            }
            .sink { [weak self] brans in
                self?.updateDataSource(brands: brans)
            }
            .store(in: &cancellables)
        
        addAdvertisementModel.modelErrorPublisher
            .sink { [unowned self] error in
                isLoadingSubject.send(false)
                errorSubject.send(error)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Internal extension
extension BrandListViewModel {
    func setSelectedBrand(item: BrandRow) {
        switch item {
        case .carBrandRow(let brand):
            addAdvertisementModel.getModelsById(brand.id)
            addAdvertisementModel.setBrand(model: brand)
            transitionSubject.send(.popToPreviousModule)
        }
    }
    
    func filterByInputedText(_ brand: String) {
        searchTextSubject.send(brand)
    }
}

// MARK: - Private extension
private extension BrandListViewModel {
    func updateDataSource(brands: [BrandDomainModel]) {
        let brandRow: [BrandRow] = brands.map { BrandRow.carBrandRow(.init(brandDomainModel: $0)) }
        self.sectionsSubject.send([.init(section: .brandSection, items: brandRow)])
    }
}
