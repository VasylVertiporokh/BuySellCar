//
//  DetailsViewModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 01/08/2023.
//

import Combine

final class DetailsViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<DetailsTransition, Never>()
    
//    init() {
//
//        super.init()
//    }
    
}
