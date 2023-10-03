//
//  VehicleDetailsView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 22.05.2023.
//

import UIKit
import SnapKit
import CombineCocoa
import Combine

final class VehicleDetailsView: BaseView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let separatorView = UIView()
    private let vehicleDataStackView = UIStackView()
    private let vehicleDataTitleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let detailsStackView = UIStackView()
    private let dataTitlesStackView = UIStackView()
    private let dataDescriptionStackView = UIStackView()
    private let conditionTitleLabel = UILabel()
    private let bodyTypeLabel = UILabel()
    private let bodyColorLabel = UILabel()
    private let doorCountLabel = UILabel()
    private let numberOfSeatsLabel = UILabel()
    private let conditionDescriptionLabel = UILabel()
    private let bodyTypeDescriptionLabel = UILabel()
    private let bodyColorDescriptionLabel = UILabel()
    private let doorCountDescriptionLabel = UILabel()
    private let numberOfSeatsDescriptionLabel = UILabel()
    
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
extension VehicleDetailsView {
    func setCarDetailsFromModel(_ model: AddAdvertisementDomainModel) {
        conditionDescriptionLabel.text = model.condition.rawValue
        bodyTypeDescriptionLabel.text = model.bodyType.rawValue
        bodyColorDescriptionLabel.text = model.bodyColor?.rawValue
        doorCountDescriptionLabel.text = "\(model.doorCount)"
        numberOfSeatsDescriptionLabel.text = "\(model.numberOfSeats)"
    }
}

// MARK: - Private extension
private extension VehicleDetailsView {
    func initialSetup() {
        setupLayout()
        configureStackViews()
        configureUI()
        setupGesture()
    }
    
    func setupLayout() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(vehicleDataStackView)
        vehicleDataStackView.addArrangedSubview(vehicleDataTitleLabel)
        vehicleDataStackView.addSpacer()
        vehicleDataStackView.addArrangedSubview(arrowImageView)
        containerStackView.addArrangedSubview(detailsStackView)
        detailsStackView.addArrangedSubview(dataTitlesStackView)
        dataTitlesStackView.addArrangedSubview(conditionTitleLabel)
        dataTitlesStackView.addArrangedSubview(bodyTypeLabel)
        dataTitlesStackView.addArrangedSubview(bodyColorLabel)
        dataTitlesStackView.addArrangedSubview(doorCountLabel)
        dataTitlesStackView.addArrangedSubview(numberOfSeatsLabel)
        detailsStackView.addArrangedSubview(dataDescriptionStackView)
        dataDescriptionStackView.addArrangedSubview(conditionDescriptionLabel)
        dataDescriptionStackView.addArrangedSubview(bodyTypeDescriptionLabel)
        dataDescriptionStackView.addArrangedSubview(bodyColorDescriptionLabel)
        dataDescriptionStackView.addArrangedSubview(doorCountDescriptionLabel)
        dataDescriptionStackView.addArrangedSubview(numberOfSeatsDescriptionLabel)
        containerStackView.addArrangedSubview(separatorView)
        
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        arrowImageView.snp.makeConstraints {
            $0.height.equalTo(Constant.arrowImageViewHeight)
            $0.width.equalTo(Constant.arrowImageViewWidth)
        }
        
        separatorView.snp.makeConstraints { $0.height.equalTo(Constant.separatorViewHeight) }
    }
    
    func configureUI() {
        separatorView.backgroundColor = .lightGray
        arrowImageView.image = Assets.arrow.image
        configureLabels()
    }
    
    func configureStackViews() {
        containerStackView.axis = .vertical
        containerStackView.spacing = Constant.containerStackViewSpacing
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewMargins
        
        vehicleDataStackView.axis = .horizontal
        vehicleDataStackView.isLayoutMarginsRelativeArrangement = true
        vehicleDataStackView.layoutMargins = Constant.vehicleDataStackViewMargins
        
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
        vehicleDataTitleLabel.text = "Vehicle data"
        conditionTitleLabel.text = "Condition"
        bodyTypeLabel.text = "Body type"
        bodyColorLabel.text = "Body color"
        doorCountLabel.text = "Door count"
        numberOfSeatsLabel.text = "Number of seats"
        [
            vehicleDataTitleLabel, conditionTitleLabel, bodyTypeLabel, bodyColorLabel, doorCountLabel,
            numberOfSeatsLabel, conditionDescriptionLabel, bodyTypeDescriptionLabel, bodyColorDescriptionLabel,
            doorCountDescriptionLabel, numberOfSeatsDescriptionLabel
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
    static let vehicleDataStackViewMargins: UIEdgeInsets = .init(top: .zero, left: .zero, bottom: .zero, right: 16)
    static let detailsStackViewMargins: UIEdgeInsets = .init(top: .zero, left: .zero, bottom: 10, right: .zero)
    static let arrowImageViewHeight: CGFloat = 14
    static let arrowImageViewWidth: CGFloat = 7
    static let separatorViewHeight: CGFloat = 0.3
    static let defaultSpacing: CGFloat = 8
    static let labelFont: UIFont = FontFamily.Montserrat.regular.font(size: 14)
}
