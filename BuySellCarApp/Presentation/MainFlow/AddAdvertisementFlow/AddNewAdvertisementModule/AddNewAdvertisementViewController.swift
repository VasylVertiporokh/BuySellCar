//
//  AddNewAdvertisementViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 11.05.2023.
//

import UIKit

final class AddNewAdvertisementViewController: BaseViewController<AddNewAdvertisementViewModel> {
    // MARK: - Views
    private let contentView = AddNewAdvertisementView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupNavigationBar()
    }
}

// MARK: - Private extension
private extension AddNewAdvertisementViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .createAd:
                    print("Start adding")
                case .deleteAd(let deleteItem):
                    deleteAdsAlert { [weak self] _ in
                        self?.viewModel.deleteAdvertisement(item: deleteItem)
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionPublisher
            .sink { [unowned self] model in
                contentView.setupSnapshot(sections: model)
            }
            .store(in: &cancellables)
        
        viewModel.eventsPublisher
            .sink { [unowned self] events in
                switch events {
                case .hasUserOwnAdvertisement(let hasUserOwnAdvertisement):
                    contentView.configureIfEmptyState(hasUserOwnAdvertisement)
                }
            }
            .store(in: &cancellables)
    }
    
    func setupNavigationBar() {
        title = Localization.selling
    }
    
    func deleteAdsAlert(action: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(
            title: Localization.deleteAdsTitle,
            message: Localization.deleteAdsMessage,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: Localization.ok, style: .destructive, handler: action)
        let cancel = UIAlertAction(title: Localization.cancel, style: .default)
        alertController.addAction(okAction)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}
