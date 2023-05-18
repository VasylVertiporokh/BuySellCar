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
    
    // MARK: - Init
    init(addAdvertisementModel: AddAdvertisementModel) {
        self.addAdvertisementModel = addAdvertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        addAdvertisementModel.modelsPublisher
            .sink { [unowned self] models in
                let modelRow: [CarModelRow] = models.map { CarModelRow.carModelRow(.init(brandDomainModel: $0)) }
                self.sectionsSubject.send([.init(section: .carModelSection, items: modelRow)])
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
}
