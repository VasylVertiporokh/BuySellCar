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
    
    // MARK: - Init
    init(addAdvertisementModel: AddAdvertisementModel) {
        self.addAdvertisementModel = addAdvertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        addAdvertisementModel.getBrands()
        addAdvertisementModel.brandsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] brands in
                guard let self = self else {
                    return
                }
                let brandRow: [BrandRow] = brands.map { BrandRow.carBrandRow(.init(brandDomainModel: $0)) }
                self.sectionsSubject.send([.init(section: .brandSection, items: brandRow)])
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
        }
    }
}
