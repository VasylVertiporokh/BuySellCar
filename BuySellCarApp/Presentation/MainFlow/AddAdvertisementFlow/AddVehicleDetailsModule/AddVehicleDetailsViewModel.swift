//
//  AddVehicleDetailsViewModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 23/09/2023.
//

import Combine


final class AddVehicleDetailsViewModel: BaseViewModel, ObservableObject {
    // MARK: -
    @Published var detailsModel: [VehicleDataCellModel] = []
    
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AddVehicleDetailsTransition, Never>()
    
    // MARK: - Init
    init(addAdvertisementModel: AddAdvertisementModel) {
        self.addAdvertisementModel = addAdvertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        super.onViewDidLoad()
        setupBindings()
        addAdvertisementModel.getBrands()
    }
}

// MARK: - Internal extension
extension AddVehicleDetailsViewModel {
    func showSelectedData(type: VehicleDataType) {
        switch type {
        case .bodyColor:
            transitionSubject.send(.showBodyColor)
        case .model:
            addAdvertisementModel.getModelsForCurrentBrand()
            transitionSubject.send(.showModel)
        case .fuelType:
            transitionSubject.send(.showFuelType)
        case .numberOfSeats:
            transitionSubject.send(.showNumberOfSeats)
        case .doorCount:
            transitionSubject.send(.showNumberOfDoor)
        case .bodyType:
            transitionSubject.send(.showBodyType)
        case .condition:
            transitionSubject.send(.showCondition)
        default:
            break
        }
    }
}

// MARK: - Private extension
private extension AddVehicleDetailsViewModel {
    func setupBindings() {
        addAdvertisementModel.addAdsDomainModelPublisher
            .sink { [unowned self] model in
                let carModel = model.model
                    .map { VehicleDataCellModel.init(dataType: .model, dataDescriptionTitle: $0) }
                
                let fuelType = model.fuelType
                    .map { VehicleDataCellModel.init(dataType: .fuelType, dataDescriptionTitle: $0.rawValue) }
                
                let bodyColor = model.bodyColor
                    .map { VehicleDataCellModel.init(dataType: .bodyColor, dataDescriptionTitle: $0.rawValue) }
                
                let doorCount = VehicleDataCellModel.init(
                    dataType: .doorCount,
                    dataDescriptionTitle: model.doorCount.description
                )
                
                let condition = VehicleDataCellModel.init(
                    dataType: .condition,
                    dataDescriptionTitle: model.condition.rawValue
                )
                
                let numberOfSeats = VehicleDataCellModel.init(
                    dataType: .numberOfSeats,
                    dataDescriptionTitle: model.numberOfSeats.description
                )
                
                let bodyType = VehicleDataCellModel.init(
                    dataType: .bodyType,
                    dataDescriptionTitle: model.bodyType.rawValue
                )
                
                detailsModel = [carModel, fuelType, bodyColor, doorCount, condition, numberOfSeats, bodyType]
                    .compactMap { $0 }
            }
            .store(in: &cancellables)
    }
}
