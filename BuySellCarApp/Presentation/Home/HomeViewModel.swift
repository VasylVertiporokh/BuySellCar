//
//  HomeViewModel.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 20.11.2021.
//

import Combine
import Foundation

final class HomeViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<HomeTransition, Never>()
    
    override init() {
        super.init()
    }
    
    override func onViewDidAppear() {
        super.onViewDidAppear()

    }

    func showDetail(for dog: DogResponseModel) {
        debugPrint("show detail for ", dog)
    }
}
