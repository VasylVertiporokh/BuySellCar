//
//  CarouselImageViewModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 08/08/2023.
//

import Combine

final class CarouselImageViewModel: BaseViewModel {
    private let model: CarouselImageView.ViewModel
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<CarouselImageTransition, Never>()
    
    // MARK: - Images publisher
    private(set) lazy var modelPublisher = modelSubject.eraseToAnyPublisher()
    private let modelSubject = CurrentValueSubject<CarouselImageView.ViewModel?, Never>(nil)
    
    // MARK: - Init
    init(model:  CarouselImageView.ViewModel) {
        self.model = model
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        updateModel()
    }
}

// MARK: - Private extension
private extension CarouselImageViewModel {
    func updateModel() {
        modelSubject.value = model
    }
}
