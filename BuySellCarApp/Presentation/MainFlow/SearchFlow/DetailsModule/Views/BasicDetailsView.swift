//
//  BasicDetailsView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 02/08/2023.
//

import UIKit
import SnapKit

final class BasicDetailsView: BaseView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let horisontalStackView = UIStackView()
    private let leftVerticalStackView = UIStackView()
    private let rightVerticalStackView = UIStackView()
    private let millageView = DetailViewSegmentView()
    private let transmissionView = DetailViewSegmentView()
    private let registrationView = DetailViewSegmentView()
    private let fuelTypeView = DetailViewSegmentView()
    private let powerView = DetailViewSegmentView()
    private let sellerView = DetailViewSegmentView()
    
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
extension BasicDetailsView: ModelConfigurableView {
    typealias Model = ViewModel
    
    func configure(model: ViewModel) {
        millageView.configure(model:
                .init(
                    image: model.millageImage,
                    title: model.millageTitle,
                    subTitle: model.millage
                )
        )
        
        transmissionView.configure(
            model: .init(
                image: model.transmissionImage,
                title: model.transmissionTitle,
                subTitle: model.transmission)
        )
        
        registrationView.configure(
            model: .init(
                image: model.registrationImage,
                title: model.registrationTitle,
                subTitle: model.registration
            )
        )
        
        fuelTypeView.configure(
            model: .init(
                image: model.fuelTypeImage,
                title: model.fuelTypeTitle,
                subTitle: model.fuelType
            )
        )
        
        powerView.configure(
            model: .init(
                image: model.powerImage,
                title: model.powerTitle,
                subTitle: model.power
            )
        )
        
        sellerView.configure(
            model: .init(
                image: model.sellerImage,
                title: model.sellerTitle,
                subTitle: model.seller
            )
        )
    }
    
    struct ViewModel {
        let millageImage: UIImage = Assets.millage.image
        let millageTitle: String = "Millage"
        let millage: String
        let registrationImage: UIImage = Assets.calendar.image
        let registrationTitle: String = "First registration"
        let registration: String
        let powerImage: UIImage = Assets.speedometer.image
        let powerTitle: String = "Power"
        let power: String
        let transmissionImage: UIImage = Assets.gearbox.image
        let transmissionTitle: String = "Transmission"
        let transmission: String
        let fuelTypeImage: UIImage = Assets.fuel.image
        let fuelTypeTitle: String = "Fuel type"
        let fuelType: String
        let sellerImage: UIImage = Assets.sellerIcon.image
        let sellerTitle: String = "Seller"
        let seller: String
        
        // MARK: - Init
        init(domainModel: AdvertisementDomainModel) {
            self.millage = "\(domainModel.mileage) km"
            self.registration = domainModel.transmissionType.rawValue
            self.power = "\(domainModel.power) hp"
            self.transmission = domainModel.transmissionType.rawValue
            self.fuelType = domainModel.fuelType.rawValue
            self.seller = domainModel.sellerType.rawValue
        }
    }
}

// MARK: - Private extension
private extension BasicDetailsView {
    func initialSetup() {
        setupLayout()
    }
    
    func setupLayout() {
        // containerStackView
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constant.containerStackViewMargins
        containerStackView.spacing = Constant.containerStackViewSpacing
        containerStackView.axis = .vertical
        containerStackView.addArrangedSubview(horisontalStackView)
        containerStackView.addSeparator()
                
        // horisontalStackView
        horisontalStackView.spacing = Constant.horisontalStackViewSpacing
        horisontalStackView.axis = .horizontal
        horisontalStackView.distribution = .fillEqually
        horisontalStackView.addArrangedSubview(leftVerticalStackView)
        horisontalStackView.addArrangedSubview(rightVerticalStackView)
        
        // leftVerticalStackView
        leftVerticalStackView.axis = .vertical
        leftVerticalStackView.spacing = Constant.defaultSpacing
        leftVerticalStackView.addArrangedSubview(millageView)
        leftVerticalStackView.addArrangedSubview(registrationView)
        leftVerticalStackView.addArrangedSubview(powerView)
        
        // rightVerticalStackView
        rightVerticalStackView.axis = .vertical
        rightVerticalStackView.spacing = Constant.defaultSpacing
        rightVerticalStackView.addArrangedSubview(transmissionView)
        rightVerticalStackView.addArrangedSubview(fuelTypeView)
        rightVerticalStackView.addArrangedSubview(sellerView)
        
        addSubview(containerStackView)
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

// MARK: - Constant
private enum Constant {
    static let containerStackViewMargins: UIEdgeInsets = .init(top: 10, left: 20, bottom: 8, right: 20)
    static let defaultSpacing: CGFloat = 10
    static let horisontalStackViewSpacing: CGFloat =  32
    static let mainInfoStackViewSpacing: CGFloat = 6
    static let containerStackViewSpacing: CGFloat = 8
}
