//
//  AddNewAdvertisementViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 11.05.2023.
//

import Combine
import Foundation

enum AddNewAdvertisementViewModelEvents {
    case hasUserOwnAdvertisement(Bool)
}

final class AddNewAdvertisementViewModel: BaseViewModel {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    private var advertisementCellModel: [AdvertisementCellModel] = []
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AddNewAdvertisementTransition, Never>()
    
    // MARK: - Section publisher
    private(set) lazy var sectionPublisher = sectionSubject.eraseToAnyPublisher()
    private let sectionSubject = CurrentValueSubject<[SectionModel<CreatedAdvertisementsSection, CreatedAdvertisementsRow>], Never>([])
    
    // MARK: - Events publisher
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<AddNewAdvertisementViewModelEvents, Never>()
    
    // MARK: - Init
    init(addAdvertisementModel: AddAdvertisementModel) {
        self.addAdvertisementModel = addAdvertisementModel
        super.init()
    }
    
    // MARK: - Overrided methods
    override func onViewDidLoad() {
        setupBindings()
        addAdvertisementModel.getOwnAds()
    }
}

// MARK: - Internal extension
extension AddNewAdvertisementViewModel {
    func deleteAdvertisement(item: CreatedAdvertisementsRow) {
        self.isLoadingSubject.send(true)
        switch item {
        case .createdAdvertisementsRow(let advertisementCellModel):
            addAdvertisementModel.deleteAdvertisementByID(advertisementCellModel.objectID)
        }
    }
}
 
// MARK: - Private extension
private extension AddNewAdvertisementViewModel {
    func setupBindings() {
        isLoadingSubject.send(true)
        addAdvertisementModel.ownAdsPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self.errorSubject.send(error)
                self.isLoadingSubject.send(false)
            } receiveValue: { [weak self] ownAdsModel in
                guard let self = self else {
                    return
                }
                self.isLoadingSubject.send(false)
                self.advertisementCellModel = ownAdsModel.map { AdvertisementCellModel.init(model: $0) }
                self.eventsSubject.send(.hasUserOwnAdvertisement(!ownAdsModel.isEmpty))
                self.updateDataSource()
            }
            .store(in: &self.cancellables)
        
        addAdvertisementModel.modelErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else {
                    return
                }
                self.isLoadingSubject.send(false)
                self.errorSubject.send(error)
            }
            .store(in: &cancellables)
    }
    
    func updateDataSource() {
        let items = advertisementCellModel.map { CreatedAdvertisementsRow.createdAdvertisementsRow($0) }
        sectionSubject.send([.init(section: .createdAdvertisements, items: items)])
    }
}
