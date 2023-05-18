//
//  VehicleDataViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import Combine
import Foundation

// MARK: - VehicleDataType
enum VehicleDataType: String {
    case make = "Make"
    case firstRegistration = "First registration"
    case bodyColor = "Body color"
    case model = "Model"
    case fuelType = "Fuel type"
}

// MARK: - VehicleDataViewModelEvents
enum VehicleDataViewModelEvents {
    case isAllFieldsValid(Bool)
}

final class VehicleDataViewModel: BaseViewModel {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    private var vehicleDataRows: [VehicleDataCellModel] = []
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<VehicleDataTransition, Never>()
    
    // MARK: - Section publisher
    private(set) lazy var sectionsPublisher = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<VehicleDataSection, VehicleDataRow>], Never>([])
    
    // MARK: - Events publisher
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<VehicleDataViewModelEvents, Never>()
    
    // MARK: - Init
    init(addAdvertisementModel: AddAdvertisementModel) {
        self.addAdvertisementModel = addAdvertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        addAdvertisementModel.addAdsDomainModelPublisher
            .sink { [weak self] model in
                guard let self = self else {
                    return
                }
                self.configureSteps(model)
            }
            .store(in: &cancellables)
        
        addAdvertisementModel.isAllFieldsValidPublisher
            .removeDuplicates()
            .dropFirst()
            .sink { [weak self] in
                guard let self = self else {
                    return
                }
                self.eventsSubject.send(.isAllFieldsValid($0)) }
            .store(in: &cancellables)
    }
    
    // MARK: - Deinit
    deinit {
        addAdvertisementModel.resetAdCreation()
    }
}

// MARK: - Internal extension
extension VehicleDataViewModel {
    func didSelect(_ row: VehicleDataRow) {
        guard case let .vehicleDataRow(dataTypeModel) = row else { return }
        switch dataTypeModel.dataType {
        case .make:                transitionSubject.send(.showBrands)
        case .model:               transitionSubject.send(.showModels)
        case .firstRegistration:   transitionSubject.send(.showRegistrationDate)
        case .fuelType:            transitionSubject.send(.showFuelType)
        case .bodyColor:           transitionSubject.send(.showBodyColor)
        }
    }
}

// MARK: - Private extension
private extension VehicleDataViewModel {
    func updateDataSource() {
        let rows = vehicleDataRows.map { VehicleDataRow.vehicleDataRow($0) }
        sectionsSubject.send([.init(section: .vehicleDataSection, items: rows)])
    }
    
    func configureSteps(_ model: AddAdvertisementDomainModel) {
        let make = VehicleDataCellModel.init(dataType: .make, dataDescriptionTitle: model.make)
        let carModel = model.model.map { VehicleDataCellModel.init(dataType: .model, dataDescriptionTitle: $0) }
        let registration = model.firstRegistration.map { VehicleDataCellModel.init(dataType: .firstRegistration, dataDescriptionTitle: $0.dateString)}
        let fuelType = model.fuelType.map { VehicleDataCellModel.init(dataType: .fuelType, dataDescriptionTitle: $0.rawValue) }
        let bodyColor = model.bodyColor.map { VehicleDataCellModel.init(dataType: .bodyColor, dataDescriptionTitle: $0.rawValue) }
        
        vehicleDataRows = [make, carModel, registration, fuelType, bodyColor].compactMap { $0 }
        updateDataSource()
    }
}
