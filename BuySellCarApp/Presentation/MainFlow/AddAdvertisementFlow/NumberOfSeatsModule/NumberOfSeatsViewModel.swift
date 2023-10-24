//
//  NumberOfSeatsViewModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 27/09/2023.
//

import Combine

final class NumberOfSeatsViewModel: BaseViewModel, ObservableObject {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    
    // MARK: - Seats items
    @Published var items = [CheckBoxCell.Model]()
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<NumberOfSeatsTransition, Never>()
    
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
extension NumberOfSeatsViewModel {
    func setNumberOfSeats(_ seatsNumber: Int) {
        addAdvertisementModel.setNumberOfSeats(seatsNumber)
    }
}

// MARK: - Private extension
private extension NumberOfSeatsViewModel {
    func setupBindings() {
        addAdvertisementModel.addAdsDomainModelPublisher
            .sink { [unowned self] model in
                updateDataSourceModel(selectedSeats: model.numberOfSeats)
            }
            .store(in: &cancellables)
    }
    
    func updateDataSourceModel(selectedSeats: Int) {
        let seatsAllCases = NumberOfSeats.allCases
        items = seatsAllCases
            .map {
                .init(
                    isSelected: $0.rawValue == selectedSeats,
                    descriprion: $0.description,
                    itemCount: $0.rawValue
                )
            }
    }
}
