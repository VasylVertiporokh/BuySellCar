//
//  ModelListViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 17.05.2023.
//

import Combine
import Foundation

final class ModelListViewModel: BaseViewModel {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<ModelListTransition, Never>()
    
    // MARK: - Section publisher
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<CarModelSection, CarModelRow>], Never>([])
    
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
        searchTextSubject
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .combineLatest(addAdvertisementModel.modelsPublisher)
            .map { (searchText, brands) -> [ModelsDomainModel] in
                if searchText.isEmpty {
                    return brands
                }
                return brands.filter { $0.modelName.hasPrefix(searchText) }
            }
            .sink { [weak self] models in
                self?.updateDataSource(models: models)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Internal extension
extension ModelListViewModel {
    func setSelectedModel(row: CarModelRow) {
        switch row {
        case .carModelRow(let model):
            addAdvertisementModel.setModel(model: model)
            transitionSubject.send(.popToPreviousModule)
        }
    }
    
    func filterByInputedText(_ brand: String) {
        searchTextSubject.send(brand)
    }
}

// MARK: - Private extension
private extension ModelListViewModel {
    func updateDataSource(models: [ModelsDomainModel]) {
        let modelRow: [CarModelRow] = models.map { CarModelRow.carModelRow(.init(brandDomainModel: $0)) }
        self.sectionsSubject.send([.init(section: .carModelSection, items: modelRow)])
    }
}
