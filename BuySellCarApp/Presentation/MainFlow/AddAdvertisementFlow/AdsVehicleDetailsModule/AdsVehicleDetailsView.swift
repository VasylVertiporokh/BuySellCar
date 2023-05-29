//
//  AdsVehicleDetailsView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import UIKit
import SnapKit
import Combine

enum AdsVehicleDetailsViewAction {
    case addPhotoDidTapped
    case changeFirstRegistrationDidTapped
    case priceEntered(Int)
    case powerEntered(Int)
    case millageEntered(Int)
    case discardCreation
    case publishAds
}

final class AdsVehicleDetailsView: BaseView {
    // MARK: - Subviews
    private let progressView = CreatingProgressView()
    private let scrollView = UIScrollView()
    private let containerStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private let discardButton = UIButton(type: .system)
    private let publishButton = UIButton(type: .system)
    private let mainInfoView = MainCarInfoView()
    private let vehicleDetailsView = VehicleDetailsView()
    private let engineAndEnvironmentView = EngineAndEnvironmentView()
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdsVehicleDetailsViewAction, Never>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        publishButton.rounded(Constant.buttonRadius)
        discardButton.rounded(Constant.buttonRadius)
    }
}

// MARK: - Internal extension
extension AdsVehicleDetailsView {
    func configureWithData(_ model: AddAdvertisementDomainModel) {
        mainInfoView.setMainDetailsFromModel(model)
        vehicleDetailsView.setCarDetailsFromModel(model)
        engineAndEnvironmentView.setTransmissionDetail(model)
        mainInfoView.setEmptyState(model.adsPhotoModel.allSatisfy { $0.selectedImage.isNil })
    }
    
    func setupSnapshot(sections: [SectionModel<SelectedImageSection, SelectedImageRow>]) {
        mainInfoView.setupSnapshot(sections: sections)
    }
    
    func reconfigureProgressBar(_ step: CreatingProgressView.CreatingProgressViewStep) {
        progressView.configureForStep(step)
    }
    
    func showDataMissingState() {
        mainInfoView.shakeTextFields()
    }
}

// MARK: - Private extension
private extension AdsVehicleDetailsView {
    func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }
    
    func bindActions() {
        publishButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.publishAds) }
            .store(in: &cancellables)
        
        discardButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.discardCreation) }
            .store(in: &cancellables)
        
        
        mainInfoView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .price(let price):
                    actionSubject.send(.priceEntered(price))
                case .power(let power):
                    actionSubject.send(.powerEntered(power))
                case .millage(let millage):
                    actionSubject.send(.millageEntered(millage))
                case .addPhotoDidTapped:
                    actionSubject.send(.addPhotoDidTapped)
                case .changeRegistrationDidTapped:
                    actionSubject.send(.changeFirstRegistrationDidTapped)
                }
            }
            .store(in: &cancellables)
        
        keyboardHeightPublisher
            .sink { [unowned self] keyboardHeight in
                scrollView.contentInset.bottom = keyboardHeight
            }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        backgroundColor = .white
        progressView.configureForStep(.vehicleData)
        discardButton.setTitle("Discard", for: .normal)
        discardButton.backgroundColor = Constant.discardButtonColor
        discardButton.tintColor = Colors.buttonDarkGray.color
        discardButton.bordered(width: Constant.discardButtonBorderWidth, color: Colors.buttonDarkGray.color)
        discardButton.titleLabel?.font = Constant.buttonFont
        
        publishButton.setTitle("Publish", for: .normal)
        publishButton.tintColor = Colors.buttonDarkGray.color
        publishButton.backgroundColor = Colors.buttonYellow.color
        publishButton.titleLabel?.font = Constant.buttonFont
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset.top = Constant.scrollViewTopInset
        scrollView.contentInset.bottom = Constant.scrollViewTopInset
    }
    
    func setupLayout() {
        addSubview(scrollView)
        addSubview(progressView)
        scrollView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(mainInfoView)
        containerStackView.addArrangedSubview(vehicleDetailsView)
        containerStackView.addArrangedSubview(engineAndEnvironmentView)
        addSubview(buttonStackView)
        
        containerStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = Constant.buttonStackViewSpacing
        buttonStackView.addArrangedSubview(discardButton)
        buttonStackView.addArrangedSubview(publishButton)
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(snp.leading)
            $0.trailing.equalTo(snp.trailing)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
            $0.width.equalTo(snp.width)
        }
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(Constant.buttonStackViewHeight)
            $0.leading.equalTo(snp.leading).offset(Constant.defaultConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.defaultConstraint)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - View constants
private enum Constant {
    static let defaultConstraint: CGFloat = 16
    static let buttonStackViewHeight: CGFloat = 47
    static let scrollViewTopInset: CGFloat = 68
    static let discardButtonColor: UIColor = .white.withAlphaComponent(0.8)
    static let buttonFont: UIFont = FontFamily.Montserrat.medium.font(size: 12)
    static let discardButtonBorderWidth: CGFloat = 2
    static let buttonStackViewSpacing: CGFloat = 8
    static let buttonRadius: CGFloat = 8
}
