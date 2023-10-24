//
//  BodyTypeViewModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 28/09/2023.
//

import Combine

final class BodyTypeViewModel: BaseViewModel, ObservableObject {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    
    // MARK: - Seats items
    @Published var items = [CheckBoxCell.Model]()
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<BodyTypeTransition, Never>()
    
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
extension BodyTypeViewModel {
    func setBodyType(_ bodyType: String) {
        addAdvertisementModel.setBodyType(bodyType)
    }
}

// MARK: - Private extension
private extension BodyTypeViewModel {
    func setupBindings() {
        addAdvertisementModel.addAdsDomainModelPublisher
            .sink { [unowned self] model in
                updateDataSourceModel(bodyType: model.bodyType.rawValue)
            }
            .store(in: &cancellables)
    }
    
    func updateDataSourceModel(bodyType: String) {
        let bodyTypeAllCases = BodyType.allCases
        items = bodyTypeAllCases
            .map {
                .init(
                    isSelected: $0.rawValue == bodyType,
                    descriprion: $0.rawValue
                )
            }
    }
}
