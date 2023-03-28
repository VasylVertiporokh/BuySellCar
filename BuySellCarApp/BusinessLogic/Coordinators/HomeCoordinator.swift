//
//  HomeCoordinator.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import UIKit
import Combine

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private let container: AppContainer
    private var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        searchRoot()
    }
    
    deinit {
        print("Deinit of \(String(describing: self))")
    }
    
    private func searchRoot() {
        let module = AdvertisementRecomendationModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                //                switch transition {
                //
                //                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
        
    }
}
