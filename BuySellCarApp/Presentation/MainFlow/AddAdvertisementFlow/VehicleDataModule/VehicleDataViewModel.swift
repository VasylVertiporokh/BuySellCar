//
//  VehicleDataViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import Combine
import Foundation

final class VehicleDataViewModel: BaseViewModel {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    private var vehicleDataRows: [VehicleDataRow] = [.carBrandRow(.init(dataTypeTitle: "Model"))]
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<VehicleDataTransition, Never>()
    
    // MARK: - Section publisher
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<VehicleDataSection, VehicleDataRow>], Never>([])
    
    // MARK: - Init
    init(addAdvertisementModel: AddAdvertisementModel) {
        self.addAdvertisementModel = addAdvertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        sectionsSubject.send([.init(section: .vehicleDataSection, items: vehicleDataRows)])
    }
}

// MARK: - Internal extension
extension VehicleDataViewModel {
    func updateDataSource() {
        sectionsSubject.send([.init(section: .vehicleDataSection, items: vehicleDataRows)])
    }
    
    func didSelect(_ row: VehicleDataRow) {
        switch row {
        case .carBrandRow:
            transitionSubject.send(.showBrands)
        case .firstRegistrationRow:
            print("vehicleDataCellModel")
        case .bodyColorRow:
            print("vehicleDataCellModel")
        case .modelRow:
            print("vehicleDataCellModel")
        case .fuelTypeRow:
            print("vehicleDataCellModel")
        }
    }
}
