//
//  AddAdvertisementImageViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.05.2023.
//

import Combine
import Foundation

final class AddAdvertisementImageViewModel: BaseViewModel {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    private var adsPhotoModel: [AdsPhotoModel]!
    private var collageID: String = ""
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AddAdvertisementImageTransition, Never>()
    
    // MARK: - Section publisher
    private(set) lazy var sectionPublisher = sectionSubject.eraseToAnyPublisher()
    private let sectionSubject = CurrentValueSubject<[SectionModel<AddAdvertisementImageSection, AddAdvertisementImageRow>], Never>([])
    
    // MARK: - Init
    init(addAdvertisementModel: AddAdvertisementModel) {
        self.addAdvertisementModel = addAdvertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        setupBindings()
    }
}

// MARK: - Internal extension
extension AddAdvertisementImageViewModel {
    func addPhoto(_ photo: Data?) {
        addAdvertisementModel.setAdvertisementPhoto(photo, collageID: collageID)
    }
    
    func deleteSelectedPhoto() {
        addAdvertisementModel.deleteImageByID(collageID)
    }
    
    func setSelectedCollageID(_ id: String) {
        collageID = id
    }
}

// MARK: - Private extension
private extension AddAdvertisementImageViewModel {
    func setupBindings() {
        addAdvertisementModel.addAdsDomainModelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] domainModel in
                adsPhotoModel = domainModel.adsPhotoModel
                updateDataSource()
            }
            .store(in: &cancellables)
    }
    
    func updateDataSource() {
        let rows = adsPhotoModel.map { AddAdvertisementImageRow.carImageRow($0) }
        sectionSubject.send([.init(section: .addAdvertisementImage, items: rows)])
    }
}
