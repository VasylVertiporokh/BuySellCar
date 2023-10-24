//
//  DoorCountViewModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/09/2023.
//

import Combine

final class DoorCountViewModel: BaseViewModel, ObservableObject {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    
    // MARK: - Seats items
    @Published var items = [CheckBoxCell.Model]()
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<DoorCountTransition, Never>()
    
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
extension DoorCountViewModel {
    func setNumberOfDoors(_ doorNumber: Int) {
        addAdvertisementModel.setNumberOfDoors(doorNumber)
    }
}

// MARK: - Private extension
private extension DoorCountViewModel {
    func setupBindings() {
        addAdvertisementModel.addAdsDomainModelPublisher
            .sink { [unowned self] model in
                updateDataSourceModel(selectedDoorCount: model.doorCount)
            }
            .store(in: &cancellables)
    }
    
    func updateDataSourceModel(selectedDoorCount: Int) {
        let doorAllCases = DoorCount.allCases
        items = doorAllCases
            .map {
                .init(
                    isSelected: $0.rawValue == selectedDoorCount,
                    descriprion: $0.description,
                    itemCount: $0.rawValue
                )
            }
    }
}
