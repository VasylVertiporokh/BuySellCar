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
    case needShowEmptyState(Bool)
    case publicationEditing
    case showAlert(UIAlertControllerModel)
    case currnetFlow(AddAdvertisementFlow)
}

final class AdsVehicleDetailsViewModel: BaseViewModel {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    private let flow: AddAdvertisementFlow
    private var photoModel: [CollageImagesModel]?
    
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
    
    override func onViewWillAppear() {
        setEditingState()
        eventsSubject.send(.currnetFlow(flow))
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
                isLoadingSubject.send(true)
                addAdvertisementModel.updateAdvertisement()
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
    
    func discardCreationDidTap() {
        eventsSubject.send(
            .showAlert(
                .init(
                    confirmActionStyle: .destructive,
                    title: flow == .creating ? Localization.discardCreationTitle : Localization.discardEditingTitle,
                    message: Localization.discardCreationMessage,
                    confirmButtonTitle: Localization.continue,
                    discardButtonTitle: Localization.cancel,
                    confirmAction: { [weak self] in
                        self?.transitionSubject.send(.popToRoot)
                    }
                )
            )
        )
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
                eventsSubject.send(
                    .showAlert(.init(
                        title: Localization.successfullyAlertTitle,
                        message: Localization.adsCreatedSuccessfully,
                        confirmButtonTitle: Localization.ok, confirmAction: { [weak self] in
                            self?.transitionSubject.send(.popToRoot)
                        }
                    ))
                )
                addAdvertisementModel.getOwnAds()
            }
            .store(in: &cancellables)
        
        addAdvertisementModel.addAdsDomainModelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] domainModel in
                advertisementModelSubject.send(domainModel)
            }
            .store(in: &cancellables)
        
        addAdvertisementModel.modelErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in errorSubject.send($0) }
            .store(in: &cancellables)
        
        addAdvertisementModel.collageImagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] model in
                photoModel = model
                updateDataSource()
            }
            .store(in: &cancellables)
    }
    
    func updateDataSource() {
        guard let photoModel = photoModel else {
            eventsSubject.send(.needShowEmptyState(true))
            return
        }
        
        let images: [SelectedImageRow] = photoModel
            .sorted(by: { $0.index < $1.index })
            .compactMap { .imageResources($0.collageImage) }
        sectionSubject.send([.init(section: .selectedImageSection, items: images)])
        eventsSubject.send(.needShowEmptyState(images.isEmpty))
    }
    
    func setEditingState() {
        guard flow == .editing else {
            return
        }
        eventsSubject.send(.publicationEditing)
    }
}
