//
//  HomeCoordinator.swift
//  MVVMSkeleton
//
//

import UIKit
import Combine

final class HomeCoordinator: Coordinator {
    // MARK: - Internal properties
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private(set) lazy var didFinishPublisher = didFinishSubject.eraseToAnyPublisher()
    
    // MARK: - Private properties 
    private let didFinishSubject = PassthroughSubject<Void, Never>()
    private let container: AppContainer
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
        setupNavigationBar()
    }

    // MARK: - Start flow
    func start() {
        searchRoot()
    }
    
    // MARK: - Deinit
    deinit {
        print("Deinit of \(String(describing: self))")
    }
}

// MARK: - Private extension
private extension HomeCoordinator {
    func searchRoot() {
        let module = AdvertisementRecomendationModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .showResult(let model):    showSearchResult(model: model)
                case .startSearch(let model):   startSearch(model: model)
                case .showDetails(let model):   showDetails(adsModel: model)
                }
            }
            .store(in: &cancellables)
        setRoot(module.viewController)
    }
    
    func showSearchResult(model: AdvertisementModel) {
        let module = SearchResultModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .showSearch:              startSearch(model: model, flow: .inCurrentFlow)
                case .showDetails(let ads):    showDetails(adsModel: ads)
                }
            }
            .store(in: &cancellables)
        module.viewController.hidesBottomBarWhenPushed = true
        push(module.viewController)
    }
    
    func startSearch(model: AdvertisementModel, flow: SearchFlow = .newFlow) {
        let module = SearchAdvertisementModuleBuilder.build(container: container, flow: flow)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .showResults:              showSearchResult(model: model)
                case .showBrands:               showAllMakes()
                case .showModels:               showBrandModels()
                case .popModule:                pop()
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }
    
    func showAllMakes() {
        let module = AllMakesModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .showModels:               showBrandModels()
                case .pop:                      pop()
                }
            }
            .store(in: &cancellables)
        push(module.viewController)
    }
    
    func showBrandModels() {
        let module = BrandModelsModuleBuilder.build(container: container)
        module.transitionPublisher
            .sink { [unowned self] transition in
                switch transition {
                case .dissmiss:                dismiss()
                }
            }
            .store(in: &cancellables)
        module.viewController.isModalInPresentation = true
        present(module.viewController)
    }
    
    func showDetails(adsModel: AdvertisementDomainModel) {
        let module = DetailsModuleBuilder.build(container: container, adsModel: adsModel)
        push(module.viewController)
    }
}

// MARK: - NavigationControler configuration
private extension HomeCoordinator {
    func setupNavigationBar() {
        navigationController.navigationBar.tintColor = Colors.buttonDarkGray.color
    }
}
