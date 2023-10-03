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
        configureNavigationBar()
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
                case .discardCreation:                   showDiscardAlert()
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
                    showSuccessfullyCreationAlert()
                    
                case .inputError:
                    contentView.showDataMissingState()
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
    
    func configureNavigationBar() {
        title = "Create ad"
    }
    
    func configureGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    func showSuccessfullyCreationAlert() {
        let alertController = UIAlertController(
            title: Localization.successfullyAlertTitle,
            message: Localization.adsCreatedSuccessfully,
            preferredStyle: .alert
        )
        alertController.addAction(.init(title: Localization.ok, style: .default, handler: { [weak self] _ in
            self?.viewModel.popToRoot()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func showDiscardAlert() {
        let alertController = UIAlertController(
            title: Localization.discardCreationTitle,
            message: Localization.discardCreationMessage,
            preferredStyle: .alert
        )
        
        alertController.addAction(.init(title: Localization.continue, style: .destructive, handler: { [weak self] _ in
            self?.viewModel.popToRoot()
        }))
        
        alertController.addAction(.init(title: Localization.cancel, style: .default))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Action
private extension AdsVehicleDetailsViewController {
    @objc
    func handleTap() {
        view.endEditing(true)
    }
}
