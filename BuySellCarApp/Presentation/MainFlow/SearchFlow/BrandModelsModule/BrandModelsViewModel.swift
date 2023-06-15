//
//  BrandModelsViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 30.05.2023.
//

import Combine
import Foundation

final class BrandModelsViewModel: BaseViewModel {
    // MARK: - Private properties
    private let advertisementModel: AdvertisementModel
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<BrandModelsTransition, Never>()
    
    // MARK: - Section publisher
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<CarModelSection, CarModelRow>], Never>([])
    
    // MARK: - Subjects
    private let searchTextSubject = CurrentValueSubject<String, Never>("")
    
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
            .map { (searchText, domainModel) -> [ModelsDomainModel] in
                if searchText.isEmpty {
                    return domainModel.brandModels
                }
                return domainModel.brandModels.filter { $0.modelName.hasPrefix(searchText) }
            }
            .sink { [weak self] models in
                self?.updateDataSource(models: models)
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
extension BrandModelsViewModel {
    func filterByInputedText(_ text: String) {
        searchTextSubject.send(text)
    }
    
    func setBrandModel(_ model: CarModelRow) {
        switch model {
        case .carModelRow(let model):
            advertisementModel.setModel(model)
        }
    }
}

// MARK: - Private extension
private extension BrandModelsViewModel {
    func updateDataSource(models: [ModelsDomainModel]) {
        let carModelRow: [CarModelRow] = models.map { CarModelRow.carModelRow(.init(brandDomainModel: $0)) }
        self.sectionsSubject.send([.init(section: .carModelSection, items: carModelRow)])
    }
}

