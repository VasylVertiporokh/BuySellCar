//
//  TabBarButtonView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 16/08/2023.
//

import SnapKit
import UIKit
import Combine

enum TabBarButtonViewAction {
    case buttonDidTap
}

final class TabBarButtonView: BaseView {
    // MARK: - Subviews
    private let button = UIButton(type: .system)
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<TabBarButtonViewAction, Never>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal extension
extension TabBarButtonView {
    func setState(isSelected: Bool) {
        let buttonImage: UIImage? = .init(systemName: isSelected ? "star.fill" : "star")
        spinner.stopAnimating()
        button.isHidden = false
        button.setImage(buttonImage, for: .normal)
    }
    
    func setDisabledState() {
        spinner.stopAnimating()
        button.isEnabled = false
    }
    
    func stopLoadingAnimation() {
        button.isHidden = false
        spinner.stopAnimating()
    }
    
    func startLoadingAnimation() {
        button.isHidden = true
        spinner.startAnimating()
    }
}

// MARK: - Private extension
private extension TabBarButtonView {
    func initialSetup() {
        setupLayout()
        setupUI()
        setupBindings()
    }
    
    func setupLayout() {
        addSubview(button)
        button.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.edges.equalToSuperview()
        }
        
        addSubview(spinner)
        spinner.snp.makeConstraints {
            $0.center.equalTo(snp.center)
        }
    }
    
    func setupUI() {
        spinner.color = Colors.buttonDarkGray.color
        button.setImage(.init(systemName:"star"), for: .normal)
        button.setImage(Assets.statusOfflineIcon.image, for: .disabled)
    }
    
    func setupBindings() {
        button.tapPublisher
            .sink { [unowned self] in actionSubject.send(.buttonDidTap) }
            .store(in: &cancellables)
    }
}
