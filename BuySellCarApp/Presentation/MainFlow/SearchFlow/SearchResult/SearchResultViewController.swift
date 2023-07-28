//
//  SearchResultViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.03.2023.
//

import UIKit
import SnapKit

final class SearchResultViewController: BaseViewController<SearchResultViewModel> {
    // MARK: - Views
    private let contentView = SearchResultView()
    private let navigationView = NavigationTitleView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        navigationItem.titleView = navigationView
        navigationController?.navigationBar.tintColor = Colors.buttonDarkGray.color
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .showSearch:                                     viewModel.showSearch()
                case .deleteBrandTapped(let brand):                   viewModel.deleteSelectedBrand(brand)
                case .deleteModelTapped(let model):                   viewModel.deleteModel(model)
                case .deleteBodyTapped(let type):                     viewModel.deleteBodyType(type)
                case .deleteFuelTypeTapped(let fuelType):             viewModel.deleteFuelType(fuelType)
                case .deleteTransmissionTypeTapped(let transmission): viewModel.deleteTransmissionType(transmission)
                case .deleteRegistrationTapped(let registration):     viewModel.deleteRangeParams(param: registration, type: .registration)
                case .deleteMillageTapped(let millage):               viewModel.deleteRangeParams(param: millage, type: .millage)
                case .deletePowerTapped(let power):                   viewModel.deleteRangeParams(param: power, type: .power)
                case .needLoadNextPage(let startPaging):              viewModel.loadNextPage(startPaging)
                }
            }
            .store(in: &cancellables)
        
        viewModel.eventsPublisher
            .sink { [unowned self] events in
                switch events {
                case .advertisementCount(let count):                  navigationView.setResultCount(count)
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in contentView.setupSnapshot(sections: $0) }
            .store(in: &cancellables)
        viewModel.filteredSectionPublisher
            .sink { [unowned self] in contentView.setupSearchSnapshot(sections: $0) }
            .store(in: &cancellables)
        viewModel.isPagingInProgressPublisher
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [unowned self] in contentView.setPagingState($0) }
            .store(in: &cancellables)
    }
}
