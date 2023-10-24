//
//  AdsVehicleDetailsViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import UIKit

final class AdsVehicleDetailsViewController: BaseViewController<AdsVehicleDetailsViewModel> {
    // MARK: - Views
    private let contentView = AdsVehicleDetailsView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureGesture()
        setupBindings()
    }
}

// MARK: - Private extension
private extension AdsVehicleDetailsViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .addPhotoDidTapped:                 viewModel.showAddPhotoScreen()
                case .changeFirstRegistrationDidTapped:  viewModel.changeFirstRegistrationDate()
                case .publishAds:                        viewModel.publishAds()
                case .discardCreation:                   viewModel.discardCreationDidTap()
                case .priceEntered(let price):           viewModel.setPrice(price)
                case .millageEntered(let millage):       viewModel.setMillage(millage)
                case .powerEntered(let power):           viewModel.setPower(power)
                case .vehicleDataDidTap:                 viewModel.showVehicleData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.eventsPublisher
            .sink { [unowned self] event in
                switch event {
                case .publicationInProgress:
                    contentView.reconfigureProgressBar(.creatingInProgress)
                    
                case .publicationСreatedSuccessfully:
                    contentView.reconfigureProgressBar(.created)
                    
                case .inputError:
                    contentView.showDataMissingState()
                    
                case .needShowEmptyState(let needShow):
                    contentView.showEmptyStateIfNeeded(needShow)
                    
                case .publicationEditing:
                    contentView.reconfigureProgressBar(.adsEditing)
                    
                case .showAlert(let alertModel):
                    UIAlertController.showAlert(model: alertModel)
                    
                case .currnetFlow(let flow):
                    configureNavigationBar(flow: flow)
                }
            }
            .store(in: &cancellables)
        
        viewModel.advertisementModelPublisher
            .sink { [unowned self] domainModel in
                guard let model = domainModel else {
                    return
                }
                contentView.configureWithData(model)
            }
            .store(in: &cancellables)
        
        viewModel.sectionPublisher
            .sink { [unowned self] sections in
                contentView.setupSnapshot(sections: sections)
            }
            .store(in: &cancellables)
    }
    
    func configureNavigationBar(flow: AddAdvertisementFlow) {
        switch flow {
        case .creating:
            title = "Create ad"
        case .editing:
            title = "Edit ad"
        }
    }
    
    func configureGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Action
private extension AdsVehicleDetailsViewController {
    @objc
    func handleTap() {
        view.endEditing(true)
    }
}
