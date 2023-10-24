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
    private let flow: AddAdvertisementFlow
    private var adsPhotoModel: [AdsPhotoModel] = []
    private var collageRacurs: AdsPhotoModel.Racurs = .backRightSide
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AddAdvertisementImageTransition, Never>()
    
    // MARK: - Section publisher
    private(set) lazy var sectionPublisher = sectionSubject.eraseToAnyPublisher()
    private let sectionSubject = CurrentValueSubject<[SectionModel<AddAdvertisementImageSection, AddAdvertisementImageRow>], Never>([])
    
    // MARK: - Init
    init(addAdvertisementModel: AddAdvertisementModel, flow: AddAdvertisementFlow) {
        self.addAdvertisementModel = addAdvertisementModel
        self.flow = flow
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
        guard let collageItem = adsPhotoModel.first(where: { $0.photoRacurs == collageRacurs }) else {
            return
        }
        addAdvertisementModel.setAdvertisementPhoto(photo, racurs: collageRacurs, index: collageItem.imageIndex)
    }
    
    func deleteSelectedPhoto() {
        addAdvertisementModel.deleteImageByRacurs(collageRacurs)
    }
    
    func setSelectedCollageID(_ racurs: AdsPhotoModel.Racurs) {
        collageRacurs = racurs
    }
}

// MARK: - Private extension
private extension AddAdvertisementImageViewModel {
    func setupBindings() {
        addAdvertisementModel.collageImagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] imageModel in
                guard let remoteImages = imageModel else {
                    adsPhotoModel = AdsPhotoModel.photoModel
                    updateDataSource()
                    return
                }
                
                adsPhotoModel = AdsPhotoModel.photoModel
                remoteImages.forEach { collageImageModel in
                    guard let collageIndex = adsPhotoModel.firstIndex(where: { $0.imageIndex == collageImageModel.index }) else {
                        return
                    }
                    adsPhotoModel[collageIndex].image = collageImageModel.collageImage
                    adsPhotoModel[collageIndex].photoRacurs = .init(rawValue: collageImageModel.photoRacurs)!
                }
                updateDataSource()
            }
            .store(in: &cancellables)
    }
    
    func updateDataSource() {
        let rows = adsPhotoModel.map { AddAdvertisementImageRow.carImageRow($0) }
        sectionSubject.send([.init(section: .addAdvertisementImage, items: rows)])
    }
}
