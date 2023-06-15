//
//  AdvertisementRecomendationViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.03.2023.
//

import Combine
import Foundation

final class AdvertisementRecommendationViewModel: BaseViewModel {
    // MARK: - Private properties
    private let advertisementModel: AdvertisementModel
    private var advertisementResponseModel: [AdvertisementDomainModel] = []
    
    // MARK: - Subjects
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AdvertisementRecomendationTransition, Never>()
    
    private(set) lazy var sectionsAction = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<AdvertisementSection, AdvertisementRow>], Never>([])
    
    // MARK: - Init
    init(advertisementModel: AdvertisementModel) {
        self.advertisementModel = advertisementModel
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewWillAppear() {
        isLoadingSubject.send(true)
        advertisementModel.getRecommendedAdvertisements(searchModel: .init())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.errorSubject.send(error)
                self?.isLoadingSubject.send(false)
            } receiveValue: { [weak self] advertisementDomainModel in
                guard let self = self else { return }
                self.isLoadingSubject.send(false)
                self.advertisementResponseModel = advertisementDomainModel
                self.updateDataSource(model: advertisementDomainModel)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Internal extension
extension AdvertisementRecommendationViewModel {
    func startSearch() {
        transitionSubject.send(.startSearch(advertisementModel))
    }
    
    func showSelected(_ row: AdvertisementRow) {
        switch row {
        case .recommended(let model):
            let testFilteredResult = advertisementResponseModel.filter { $0.objectID == model.objectID }
        case .trending(let model):
            advertisementModel.setFastSearсhParams(model.searchParameters)
            transitionSubject.send(.showResult(advertisementModel))
        }
    }
}

// MARK: - Private extension
private extension AdvertisementRecommendationViewModel {
    func updateDataSource(model: [AdvertisementDomainModel]) {
        let userProfileSection: SectionModel<AdvertisementSection, AdvertisementRow> = {
            let recommendedItems = model.map { AdvertisementRow.recommended(model: .init(model: $0)) }
            return .init(section: .recommended, items: recommendedItems)
        }()
        
        let trending: SectionModel<AdvertisementSection, AdvertisementRow> = {
            return .init(section: .trendingCategories, items: [
                .trending( model: .init(categoriesImage: Assets.premium.image,
                                        categoriesName: "Premium brands",
                                        searchParameters: QuickSearchParams.premiumSearchParams)),
                .trending (model: .init(categoriesImage: Assets.hybrid.image,
                                        categoriesName: "Hybrid cars",
                                        searchParameters: QuickSearchParams.hybridSearchParams)),
                .trending(model: .init(categoriesImage: Assets.roadTrip.image,
                                       categoriesName: "Road trip cars up to € 9000",
                                       searchParameters: QuickSearchParams.roadTripSearchParams)),
                .trending(model: .init(categoriesImage: Assets.suv.image,
                                       categoriesName: "Exciting SUV",
                                       searchParameters: QuickSearchParams.suvSearchParams)),
                .trending(model: .init(categoriesImage: Assets.vintage.image,
                                       categoriesName: "Vintage cars",
                                       searchParameters: QuickSearchParams.vintageSearchParams)),
                .trending(model: .init(categoriesImage: Assets.compact.image,
                                       categoriesName: "Compact cars",
                                       searchParameters: QuickSearchParams.compactSearchParams)),
                .trending(model: .init(categoriesImage: Assets.family.image,
                                       categoriesName: "FamilyCars",
                                       searchParameters: QuickSearchParams.familySearchParams)),
                .trending(model: .init(categoriesImage: Assets.electric.image,
                                       categoriesName: "Electric Cars",
                                       searchParameters: QuickSearchParams.electricSearchParams)),
            ])
        }()
        self.sectionsSubject.value = [userProfileSection, trending]
    }
}

// MARK: - QuickSearchParams
private enum QuickSearchParams { // TODO: - Add search params array to backend as JSON
    static let premiumSearchParams: [SearchParam] = [
        .init(key: .price, value: .greaterOrEqualTo(intValue: 30000)),
        .init(key: .transmissionType, value: .equalToString(stringValue: TransmissionType.automatic.rawValue)),
        .init(key: .yearOfManufacture, value: .greaterOrEqualTo(intValue: 2010))
    ]
    
    static let hybridSearchParams: [SearchParam] = [
        .init(key: .fuelType, value: .equalToString(stringValue: FuelType.hybrid.rawValue))
    ]
    
    static let roadTripSearchParams: [SearchParam] = [
        .init(key: .bodyType, value: .equalToString(stringValue: BodyType.sedan.rawValue)),
        .init(key: .price, value: .lessOrEqualTo(intValue: 9000))
    ]
    
    static let suvSearchParams: [SearchParam] = [
        .init(key: .bodyType, value: .equalToString(stringValue: BodyType.suv.rawValue)),
        .init(key: .price, value: .greaterOrEqualTo(intValue: 20000))
    ]
    
    static let vintageSearchParams: [SearchParam] = [
        .init(key: .yearOfManufacture, value: .lessOrEqualTo(intValue: 1970))
    ]
    
    static let compactSearchParams: [SearchParam] = [
        .init(key: .bodyType, value: .equalToString(stringValue: BodyType.hatchback.rawValue))
    ]
    
    static let familySearchParams: [SearchParam] = [
        .init(key: .bodyType, value: .equalToString(stringValue: BodyType.sedan.rawValue))
    ]
    
    static let electricSearchParams: [SearchParam] = [
        .init(key: .fuelType, value: .equalToString(stringValue: FuelType.electro.rawValue))
    ]
}

