//
//  AllMakesViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.05.2023.
//

import Combine
import Foundation

final class AllMakesViewModel: BaseViewModel {
    // MARK: - Private properties
    private let advertisementModel: AdvertisementModel
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AllMakesTransition, Never>()
    
    // MARK: - Section publisher
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<BrandSection, BrandRow>], Never>([])
    
    // MARK: - Subjects
    private let searchTextSubject = CurrentValueSubject<String, Never>("")
    
    // MARK: - Init
    init(advertisementModel: AdvertisementModel) {
        self.advertisementModel = advertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        searchTextSubject
            .receive(on: DispatchQueue.main)
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .combineLatest(advertisementModel.tempDomainModelPublisher)
            .map { (searchText, brands) -> [BrandDomainModel] in
                if searchText.isEmpty {
                    return brands.allBrands
                }
                return brands.allBrands.filter { $0.name.hasPrefix(searchText) }
            }
            .sink { [weak self] brans in
                self?.updateDataSource(brands: brans)
                self?.isLoadingSubject.send(false)
            }
            .store(in: &cancellables)
        
        advertisementModel.modelErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] error in
                isLoadingSubject.send(false)
                errorSubject.send(error)
            }
            .store(in: &cancellables)
    }
    
    override func onViewWillAppear() {
        isLoadingSubject.send(true)
    }
}

// MARK: - Internal extension
extension AllMakesViewModel {
    func setSelectedBrand(item: BrandRow) {
        switch item {
        case .carBrandRow(let model):
            advertisementModel.setBrand(.init(id: model.id, brand: model.brandName))
            advertisementModel.getBrandModels(id: model.id)
            transitionSubject.send(.pop)
        }
    }
    
    func filterByBrand(_ brand: String = "") {
        searchTextSubject.send(brand)
    }
}

// MARK: - Private extension
private extension AllMakesViewModel {
    func updateDataSource(brands: [BrandDomainModel]) {
        let brandRow: [BrandRow] = brands.map { BrandRow.carBrandRow(.init(brandDomainModel: $0)) }
        self.sectionsSubject.send([.init(section: .brandSection, items: brandRow)])
    }
}

