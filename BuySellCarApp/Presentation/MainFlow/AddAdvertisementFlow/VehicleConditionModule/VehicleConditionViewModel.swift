//
//  VehicleConditionViewModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 02/10/2023.
//

import Combine

final class VehicleConditionViewModel: BaseViewModel, ObservableObject {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    
    // MARK: - Seats items
    @Published var items = [CheckBoxCell.Model]()
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<VehicleConditionTransition, Never>()
    
    // MARK: - Init
    init(addAdvertisementModel: AddAdvertisementModel) {
        self.addAdvertisementModel = addAdvertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        super.onViewDidLoad()
        setupBindings()
    }
}

// MARK: - Internal extension
extension VehicleConditionViewModel {
    func setCondition(_ condition: String) {
        addAdvertisementModel.setCondition(condition)
    }
}

// MARK: - Private extension
private extension VehicleConditionViewModel {
    func setupBindings() {
        addAdvertisementModel.addAdsDomainModelPublisher
            .sink { [unowned self] model in
                updateDataSourceModel(condition: model.condition.rawValue)
            }
            .store(in: &cancellables)
    }
    
    func updateDataSourceModel(condition: String) {
        let conditionAllCases = Condition.allCases
        items = conditionAllCases
            .map {
                .init(
                    isSelected: $0.rawValue == condition,
                    descriprion: $0.rawValue
                )
            }
    }
}

