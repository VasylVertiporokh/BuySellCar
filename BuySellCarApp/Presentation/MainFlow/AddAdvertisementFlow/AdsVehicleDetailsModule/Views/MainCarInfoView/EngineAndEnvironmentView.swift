//
//  EngineAndEnvironmentView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 22.05.2023.
//

import UIKit
import SnapKit
import Combine

final class EngineAndEnvironmentView: BaseView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let separatorView = UIView()
    private let engineEnvironmentViewStackView = UIStackView()
    private let engineEnvironmentTitleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let detailsStackView = UIStackView()
    private let dataTitlesStackView = UIStackView()
    private let dataDescriptionStackView = UIStackView()
    
    private let transmissionTitleLabel = UILabel()
    private let numberOfGearTitleLabel = UILabel()
    private let cylinderTitleLabel = UILabel()
    private let engineSizeLabel = UILabel()
    private let fuelTypeLabel = UILabel()
    
    private let transmissionDescriptionLabel = UILabel()
    private let numberOfGearDescriptionLabel = UILabel()
    private let cylinderDescriptionLabel = UILabel()
    private let engineSizeDescriptionLabel = UILabel()
    private let fuelTypeDescriptionLabel = UILabel()
    
    // MARK: - Tap publisher
    private(set) lazy var tapPublisher = tapSubject.eraseToAnyPublisher()
    private let tapSubject = PassthroughSubject<Void, Never>()
    
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
extension EngineAndEnvironmentView {
    func setTransmissionDetail(_ model: AddAdvertisementDomainModel) {
        transmissionDescriptionLabel.text = model.transmissionType.rawValue
        numberOfGearDescriptionLabel.text = "6"
        cylinderDescriptionLabel.text = "-"
        engineSizeDescriptionLabel.text = "1 599"
        fuelTypeDescriptionLabel.text = model.fuelType?.rawValue
    }
}

// MARK: - Private extension
private extension EngineAndEnvironmentView {
    func initialSetup() {
        setupLayout()
        configureStackViews()
        configureUI()
    }
    
    func setupLayout() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(engineEnvironmentViewStackView)
        engineEnvironmentViewStackView.addArrangedSubview(engineEnvironmentTitleLabel)
        engineEnvironmentViewStackView.addSpacer()
        engineEnvironmentViewStackView.addArrangedSubview(arrowImageView)
        containerStackView.addArrangedSubview(detailsStackView)
        detailsStackView.addArrangedSubview(dataTitlesStackView)
        dataTitlesStackView.addArrangedSubview(transmissionTitleLabel)
        dataTitlesStackView.addArrangedSubview(numberOfGearTitleLabel)
        dataTitlesStackView.addArrangedSubview(cylinderTitleLabel)
        dataTitlesStackView.addArrangedSubview(engineSizeLabel)
        dataTitlesStackView.addArrangedSubview(fuelTypeLabel)
        detailsStackView.addArrangedSubview(dataDescriptionStackView)
        dataDescriptionStackView.addArrangedSubview(transmissionDescriptionLabel)
        dataDescriptionStackView.addArrangedSubview(numberOfGearDescriptionLabel)
        dataDescriptionStackView.addArrangedSubview(cylinderDescriptionLabel)
        dataDescriptionStackView.addArrangedSubview(engineSizeDescriptionLabel)
        dataDescriptionStackView.addArrangedSubview(fuelTypeDescriptionLabel)
        containerStackView.addArrangedSubview(separatorView)
        
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        arrowImageView.snp.makeConstraints {
            $0.height.equalTo(Constant.arrowImageViewHeight)
            $0.width.equalTo(Constant.arrowImageViewWidth)
        }
        
        separatorView.snp.makeConstraints { $0.height.equalTo(Constant.separatorViewHeight) }
    }
    
    func configureUI() {
        backgroundColor = .white
        separatorView.backgroundColor = .lightGray
        arrowImageView.image = Assets.arrow.image
        configureLabels()
        setupGesture()
    }
    
    func configureStackViews() {
        containerStackView.axis = .vertical
        containerStackView.spacing = Constant.containerStackViewSpacing
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewMargins
        
        engineEnvironmentViewStackView.axis = .horizontal
        engineEnvironmentViewStackView.isLayoutMarginsRelativeArrangement = true
        engineEnvironmentViewStackView.layoutMargins = Constant.engineEnvStackViewMargins
        
        detailsStackView.axis = .horizontal
        detailsStackView.distribution = .fillEqually
        detailsStackView.isLayoutMarginsRelativeArrangement = true
        detailsStackView.layoutMargins = Constant.detailsStackViewMargins
        
        dataTitlesStackView.axis = .vertical
        dataTitlesStackView.distribution = .fillEqually
        dataTitlesStackView.spacing = Constant.defaultSpacing
        
        dataDescriptionStackView.axis = .vertical
        dataDescriptionStackView.distribution = .fillEqually
        dataDescriptionStackView.spacing = Constant.defaultSpacing
    }
    
    func configureLabels() {
        engineEnvironmentTitleLabel.text = "Engine and Environment"
        transmissionTitleLabel.text = "Transmission"
        numberOfGearTitleLabel.text = "Number of gears"
        cylinderTitleLabel.text = "Cylinder"
        engineSizeLabel.text = "Engine size"
        fuelTypeLabel.text = "Fuel type"
        [
            engineEnvironmentTitleLabel, transmissionTitleLabel, numberOfGearTitleLabel,
            cylinderTitleLabel, engineSizeLabel, fuelTypeLabel, transmissionDescriptionLabel,
            numberOfGearDescriptionLabel, cylinderDescriptionLabel,engineSizeDescriptionLabel, fuelTypeDescriptionLabel
        ].forEach {
            $0.textColor = Colors.buttonDarkGray.color
            $0.font = Constant.labelFont
        }
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.tapPublisher.sink { [unowned self] _ in tapSubject.send() }
        .store(in: &cancellables)
        self.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Constant
private enum Constant {
    static let containerStackViewSpacing: CGFloat = 16
    static let containerStackViewMargins: UIEdgeInsets = .init(top: 16, left: 16, bottom: .zero, right: .zero)
    static let engineEnvStackViewMargins: UIEdgeInsets = .init(top: .zero, left: .zero, bottom: .zero, right: 16)
    static let detailsStackViewMargins: UIEdgeInsets = .init(top: .zero, left: .zero, bottom: 10, right: .zero)
    static let arrowImageViewHeight: CGFloat = 14
    static let arrowImageViewWidth: CGFloat = 7
    static let separatorViewHeight: CGFloat = 0.3
    static let defaultSpacing: CGFloat = 8
    static let labelFont: UIFont = FontFamily.Montserrat.regular.font(size: 14)
}
