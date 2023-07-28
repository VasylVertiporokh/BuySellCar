//
//  FirstRedistrationViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 17.05.2023.
//

import Combine
import Foundation

final class FirstRegistrationViewModel: BaseViewModel {
    // MARK: - Private properties
    private let addAdvertisementModel: AddAdvertisementModel
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<FirstRegistrationTransition, Never>()
    
    // MARK: - Init
    init(addAdvertisementModel: AddAdvertisementModel) {
        self.addAdvertisementModel = addAdvertisementModel
        super.init()
    }
}

// MARK: - Internal extension
extension FirstRegistrationViewModel {
    func setRegistrationDate(_ date: Date) {
        addAdvertisementModel.setRegistrationData(date: date)
    }
}
