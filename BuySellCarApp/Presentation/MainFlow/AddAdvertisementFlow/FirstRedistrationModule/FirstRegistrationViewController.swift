//
//  FirstRedistrationViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 17.05.2023.
//

import UIKit

final class FirstRegistrationViewController: BaseViewController<FirstRegistrationViewModel> {
    // MARK: - Views
    private let contentView = FirstRegistrationView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.launchViewAnimation()
    }
}

// MARK: - Private extension
private extension FirstRegistrationViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .firstRegistrationData(let selectedData):
                    viewModel.setRegistrationDate(selectedData)
                case .dismiss:
                    dismiss(animated: false)
                }
            }
            .store(in: &cancellables)
    }
}

