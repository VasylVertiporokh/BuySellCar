//
//  AddNewAdvertisementViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 11.05.2023.
//

import Combine

final class AddNewAdvertisementViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<AddNewAdvertisementTransition, Never>()
    
//    init() {
//
//        super.init()
//    }
//    
}
