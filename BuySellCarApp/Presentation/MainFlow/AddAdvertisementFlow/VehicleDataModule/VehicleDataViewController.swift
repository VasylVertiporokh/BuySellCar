//
//  VehicleDataViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import UIKit

final class VehicleDataViewController: BaseViewController<VehicleDataViewModel> {
    // MARK: - Views
    private let contentView = VehicleDataView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .cellDidTap(let vehicleData):
                    viewModel.didSelect(vehicleData)
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionsPublisher
            .sink { [unowned self] sections in
                contentView.setupSnapshot(sections: sections)
            }
            .store(in: &cancellables)
    }
}
