//
//  BodyColorViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import Combine

final class BodyColorViewModel: BaseViewModel {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<BodyColorTransition, Never>()
    
    // MARK: - Section publisher
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<ColorSection, CarColorRow>], Never>([])
    
    // MARK: - Init
    init(addAdvertisementModel: AddAdvertisementModel) {
        self.addAdvertisementModel = addAdvertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        updateDataSource()
    }
}

// MARK: - Internal extension
extension BodyColorViewModel {
    func setSelectedBodyColor(row: CarColorRow) {
        switch row {
        case .carColorRow(let color):
            addAdvertisementModel.setCarColor(color: color)
        }
        transitionSubject.send(.popToPreviousModule)
    }
}

// MARK: - Private extension
private extension BodyColorViewModel {
    func updateDataSource() {
        let carColorRow: [CarColorRow] = addAdvertisementModel.carColorArray.map { CarColorRow.carColorRow($0) }
        sectionsSubject.send([.init(section: .carColorSection, items: carColorRow)])
    }
}
