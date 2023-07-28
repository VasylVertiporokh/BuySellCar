//
//  FuelTypeListViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import Combine
import Foundation

final class FuelTypeListViewModel: BaseViewModel {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<FuelTypeListTransition, Never>()
    
    // MARK: - Section publisher
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<FuelTypeSection, FuelTypeRow>], Never>([])
    
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
extension FuelTypeListViewModel {
    func setSelectedFuelType(row: FuelTypeRow) { // MARK: - Fix naming
        switch row {
        case .carFuelTypeRow(let fuelType):
            addAdvertisementModel.setFuelType(type: fuelType)
        }
        transitionSubject.send(.popToPreviousModule)
    }
}

// MARK: - Private extension
private extension FuelTypeListViewModel {
    func updateDataSource() {
        let fuelTypeRow: [FuelTypeRow] = addAdvertisementModel.fuelTypesArray.map { FuelTypeRow.carFuelTypeRow($0) }
        sectionsSubject.send([.init(section: .carFuelTypeSection, items: fuelTypeRow)])
    }
}
