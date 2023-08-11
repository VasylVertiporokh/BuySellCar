//
//  CarouselImageViewController.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 08/08/2023.
//

import UIKit

final class CarouselImageViewController: BaseViewController<CarouselImageViewModel> {
    // MARK: - Views
    private let contentView = CarouselImageView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .closeDidTap:     dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.modelPublisher
            .sink { [unowned self] model in
                guard let model = model else {
                    return
                }
                contentView.configure(model: model)
            }
            .store(in: &cancellables)
    }
}
