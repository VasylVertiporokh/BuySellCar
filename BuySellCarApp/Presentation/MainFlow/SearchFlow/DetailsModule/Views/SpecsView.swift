//
//  SpecsView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 03/08/2023.
//

import UIKit
import SnapKit

final class SpecsView: BaseView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let headerStackView = UIStackView()
    private let specsStackView = UIStackView()
    private let leftStackView = UIStackView()
    private let rightStackView = UIStackView()
    private let imageView = UIImageView()
    private let headerTitleLabel = UILabel()
    private let bodyTypeTitleLabel = UILabel()
    private let bodyTypeLabel = UILabel()
    private let conditionTitleLabel = UILabel()
    private let conditionLabel = UILabel()
    private let numberOfSeatsTitleLabel = UILabel()
    private let numberOfSeatsLabel = UILabel()
    private let doorCountTitleLable = UILabel()
    private let doorCountLable = UILabel()
    private let registrationTitleLabel = UILabel()
    private let registrationLabel = UILabel()
    private let ownersTitleLabel = UILabel()
    private let ownersLabel = UILabel()
    private let colorTitleLabel = UILabel()
    private let colorLabel = UILabel()
    private let interiorColorTitleLabel = UILabel()
    private let interiorColorLabel = UILabel()
    private let avarageFuelConsumptionTitleLabel = UILabel()
    private let avarageFuelConsumptionLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ModelConfigurableView
extension SpecsView: ModelConfigurableView {
    typealias Model = ViewModel
    
    func configure(model: ViewModel) {
        imageView.image = model.headerImage
        headerTitleLabel.text = model.headerTitle
        bodyTypeTitleLabel.text = model.bodyTypeTitle
        conditionTitleLabel.text = model.conditionTitle
        numberOfSeatsTitleLabel.text = model.numberOfSeatsTitle
        doorCountTitleLable.text = model.doorCountTitle
        registrationTitleLabel.text = model.registrationTitle
        ownersTitleLabel.text = model.ownersTitle
        colorTitleLabel.text = model.colorTitle
        interiorColorTitleLabel.text = model.interiorColorTitle
        avarageFuelConsumptionTitleLabel.text = model.avarageConsumptionTitle
        bodyTypeLabel.text = model.bodyType
        conditionLabel.text = model.condition
        numberOfSeatsLabel.text = model.numberOfSeats
        doorCountLable.text = model.doorCount
        registrationLabel.text = model.registration
        ownersLabel.text = model.owners
        colorLabel.text = model.color
        interiorColorLabel.text = model.interiorColor
        avarageFuelConsumptionTitleLabel.text = model.avarageConsumptionTitle
        avarageFuelConsumptionLabel.text = model.avarageConsumption
    }
    
    struct ViewModel {
        let headerImage: UIImage = Assets.carDetailsIcon.image
        let headerTitle: String = "Vehicle data"
        let bodyTypeTitle: String = "Body type"
        let conditionTitle: String = "Condition"
        let numberOfSeatsTitle: String = "Number of seats"
        let doorCountTitle: String = "Number of doors"
        let registrationTitle: String = "First registration"
        let ownersTitle: String = "Previous Owners Count"
        let colorTitle: String = "Body color"
        let interiorColorTitle: String = "Fitting color"
        let avarageConsumptionTitle: String = "Avarage Consumption"
        let bodyType: String
        let condition: String
        let numberOfSeats: String
        let doorCount: String
        let registration: String
        let owners: String
        let color: String
        let interiorColor: String
        let avarageConsumption: String
        
        // MARK: - Init from model
        init(domainModel: AdvertisementDomainModel) {
            self.bodyType = domainModel.bodyType.rawValue
            self.condition = domainModel.condition.rawValue
            self.numberOfSeats = "\(domainModel.numberOfSeats.rawValue)"
            self.doorCount = "\(domainModel.doorCount.rawValue)"
            self.registration = "\(domainModel.yearOfManufacture)"
            self.owners = "2" // TODO: - Add to back model
            self.color = domainModel.bodyColor.rawValue
            self.interiorColor = domainModel.interiorColor.rawValue
            self.avarageConsumption = "\(domainModel.avarageFuelConsumption)"
        }
    }
}

// MARK: - Private extenison
private extension SpecsView {
    func initialSetup() {
        setupLayout()
        configureUI()
    }
    
    func setupLayout() {
        // containerStackView
        addSubview(containerStackView)
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewMargins
        containerStackView.axis = .vertical
        containerStackView.spacing = Constant.defaultSpacing
        containerStackView.addSeparator()
        containerStackView.addArrangedSubview(headerStackView)
        containerStackView.addArrangedSubview(specsStackView)
        containerStackView.addSeparator()
        
        // headerStackView
        headerStackView.spacing = Constant.headerStackViewSpacing
        headerStackView.addArrangedSubview(imageView)
        headerStackView.addArrangedSubview(headerTitleLabel)
        
        // specsStackView
        specsStackView.distribution = .fillEqually
        specsStackView.axis = .horizontal
        specsStackView.spacing = Constant.specsStackViewSpacing
        specsStackView.addArrangedSubview(leftStackView)
        specsStackView.addArrangedSubview(rightStackView)
        
        // leftStackView
        leftStackView.axis = .vertical
        leftStackView.spacing = Constant.defaultSpacing
        leftStackView.addArrangedSubview(bodyTypeTitleLabel)
        leftStackView.addArrangedSubview(conditionTitleLabel)
        leftStackView.addArrangedSubview(numberOfSeatsTitleLabel)
        leftStackView.addArrangedSubview(doorCountTitleLable)
        leftStackView.addArrangedSubview(registrationTitleLabel)
        leftStackView.addArrangedSubview(ownersTitleLabel)
        leftStackView.addArrangedSubview(colorTitleLabel)
        leftStackView.addArrangedSubview(interiorColorTitleLabel)
        leftStackView.addArrangedSubview(avarageFuelConsumptionTitleLabel)
        
        // rightStackView
        rightStackView.axis = .vertical
        rightStackView.spacing = Constant.defaultSpacing
        rightStackView.addArrangedSubview(bodyTypeLabel)
        rightStackView.addArrangedSubview(conditionLabel)
        rightStackView.addArrangedSubview(numberOfSeatsLabel)
        rightStackView.addArrangedSubview(doorCountLable)
        rightStackView.addArrangedSubview(registrationLabel)
        rightStackView.addArrangedSubview(ownersLabel)
        rightStackView.addArrangedSubview(colorLabel)
        rightStackView.addArrangedSubview(interiorColorLabel)
        rightStackView.addArrangedSubview(avarageFuelConsumptionLabel)
        
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        imageView.snp.makeConstraints { $0.size.equalTo(Constant.imageViewSize) }
    }
    
    func configureUI() {
        headerTitleLabel.textColor = .black
        headerTitleLabel.font = Constant.headerTitleLabelFont
        [
            bodyTypeTitleLabel, conditionTitleLabel, numberOfSeatsTitleLabel,
            doorCountTitleLable, registrationTitleLabel, ownersTitleLabel,
            colorTitleLabel, interiorColorTitleLabel, avarageFuelConsumptionTitleLabel
        ].forEach {
            $0.textColor = .black
            $0.font = Constant.titleLabelFont
        }
        
        [
        bodyTypeLabel, conditionLabel, numberOfSeatsLabel,
        doorCountLable, registrationLabel, ownersLabel,
        colorLabel, interiorColorLabel, avarageFuelConsumptionLabel
        ].forEach {
            $0.textColor = .black
            $0.font = Constant.detailsLabelFont
        }
    }
}

// MARK: - Constant
private enum Constant {
    static let containerStackViewMargins: UIEdgeInsets = .init(top: 10, left: 20, bottom: 8, right: 20)
    static let specsStackViewSpacing: CGFloat = 32
    static let defaultSpacing: CGFloat = 10
    static let imageViewSize: CGFloat = 24
    static let headerStackViewSpacing: CGFloat = 8
    static let headerTitleLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 14)
    static let titleLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 12)
    static let detailsLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 12)
}
