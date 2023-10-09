//
//  AdsVehicleDetailsViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import Combine
import Foundation

enum AdsVehicleDetailsViewModelEvents {
    case publicationInProgress
    case publicationСreatedSuccessfully
    case inputError
}

final class AdsVehicleDetailsViewModel: BaseViewModel {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    private let flow: AddAdvertisementFlow
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdsVehicleDetailsTransition, Never>()
    
    // MARK: - Events publisher
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<AdsVehicleDetailsViewModelEvents, Never>()
    
    // MARK: - AddAdvertisementModel publisher
    private(set) lazy var advertisementModelPublisher = advertisementModelSubject.eraseToAnyPublisher()
    private let advertisementModelSubject = CurrentValueSubject<AddAdvertisementDomainModel?, Never>(nil)
    
    // MARK: - Section publisher
    private(set) lazy var sectionPublisher = sectionSubject.eraseToAnyPublisher()
    private let sectionSubject = CurrentValueSubject<[SectionModel<SelectedImageSection, SelectedImageRow>], Never>([])
    
    // MARK: - Init
    init(addAdvertisementModel: AddAdvertisementModel, flow: AddAdvertisementFlow) {
        self.addAdvertisementModel = addAdvertisementModel
        self.flow = flow
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        setupBindings()
        addAdvertisementModel.setAddAdvertisemenOwnerId()
        addAdvertisementModel.userLocationRequest()
    }
}

// MARK: - Internal extension
extension AdsVehicleDetailsViewModel {
    func changeFirstRegistrationDate() {
        transitionSubject.send(.showRegistrationDate)
    }
    
    func showAddPhotoScreen() {
        transitionSubject.send(.showAddAdsPhotos)
    }
    
    func popToRoot() {
        transitionSubject.send(.popToRoot)
    }
    
    func publishAds() {
        guard let model = advertisementModelSubject.value else {
            return
        }
        
        switch flow {
        case .creating:
            if model.mainTechnicalInfo.isInfoValid {
                eventsSubject.send(.inputError)
            } else {
                eventsSubject.send(.publicationInProgress)
                isLoadingSubject.send(true)
                addAdvertisementModel.publishAdvertisement()
            }
        case .editing:
            if  model.mainTechnicalInfo.isInfoValid {
                eventsSubject.send(.inputError)
            } else {
                eventsSubject.send(.publicationInProgress)
                isLoadingSubject.send(true)
                // TODO: - Need add request for ads editing
                print("Need add request for ads editing")
            }
        }
    }
    
    func setMillage(_ millage: Int) {
        addAdvertisementModel.setBaseParameters(baseParams: .millage(millage))
    }
    
    func setPrice(_ price: Int) {
        addAdvertisementModel.setBaseParameters(baseParams: .price(price))
    }
    
    func setPower(_ power: Int) {
        addAdvertisementModel.setBaseParameters(baseParams: .power(power))
    }
    
    func showVehicleData() {
        transitionSubject.send(.vehicleData)
    }
}

// MARK: - Private extension
private extension AdsVehicleDetailsViewModel {
    func setupBindings() {
        addAdvertisementModel.successfulPublicationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                isLoadingSubject.send(false)
                eventsSubject.send(.publicationСreatedSuccessfully)
                addAdvertisementModel.getOwnAds()
            }
            .store(in: &cancellables)
        
        addAdvertisementModel.addAdsDomainModelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] domainModel in
                advertisementModelSubject.send(domainModel)
                updateDataSource()
            }
            .store(in: &cancellables)
        
        addAdvertisementModel.modelErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in errorSubject.send($0) }
            .store(in: &cancellables)
    }
    
    func updateDataSource() {
//        guard let photoModel = advertisementModelSubject.value?.adsPhotoModel else {
//            return
//        }
//        let photos: [Data] = photoModel.compactMap { $0.selectedImage }
//        let row: [SelectedImageRow] = photos.map { SelectedImageRow.selectedImageRow($0) }
//        sectionSubject.send([.init(section: .selectedImageSection, items: row)])
    }
}
