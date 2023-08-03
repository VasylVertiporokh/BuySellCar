//
//  DetailsView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 01/08/2023.
//

import UIKit
import SnapKit
import Combine

enum DetailsViewAction {

}

final class DetailsView: BaseView {
    // MARK: - Subviews
    private let scrollView = UIScrollView()
    private let containerStackView = UIStackView()
    private let adsImagesView = AdsImagesView()
    private let priceLocationView = PriceLocationView()
    private let basicDetailsView = BasicDetailsView()
    private let socialNetworkView = SocialNetworkView()

    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<DetailsViewAction, Never>()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
        let stringUrlArray: [String] = [
            "https://backendlessappcontent.com/702852A2-8716-0683-FF0A-5BA4B7C2DC00/E9F66CC4-A707-45CC-AD1C-0F96D2A475C4/files/images/users/1ECB4147-0A43-4581-B2D0-9C0891A0EFDC/01F1B396-F340-4364-99D2-09EAFC4D84D7.png",
            
            "https://backendlessappcontent.com/702852A2-8716-0683-FF0A-5BA4B7C2DC00/E9F66CC4-A707-45CC-AD1C-0F96D2A475C4/files/images/users/1ECB4147-0A43-4581-B2D0-9C0891A0EFDC/0249C9CC-39CF-4E0F-A632-CB62F64E5B13.png"
        ]
        adsImagesView.setupSnapshot(sections: [.init(section: .adsImageSection, items: stringUrlArray.map { .adsImageRow($0) })])
        let a = AdvertisementDomainModel.init(advertisementResponseModel: .init(bodyType: .cabrio, transportName: "Nissan", bodyColor: .red, description: "", avarageFuelConsumption: 3, ownerID: "33", interiorColor: .black, price: 3333, transmissionType: .automatic, power: 333, objectID: "33", mileage: 3333, doorCount: 3, yearOfManufacture: 3, created: 3, transportModel: "X TRAIL", interiorFittings: "", photo: "", shortDescription: "", numberOfSeats: 2, condition: .new, fuelType: .petrol, location: "Alkmar, NL", sellerType: .diller, updated: 333, sellerName: "NIK"))
        
        priceLocationView.configure(model: .init(domainModel: a))
        basicDetailsView.configure(model: .init(domainModel: a))
        socialNetworkView.configure(model: .init(image: Assets.chat.image,
                                                 title: "Chat or video call",
                                                 subtitle: "Contact this dealer using WhatsApp.",
                                                 titleButton: "Go to WhatsApp",
                                                 buttonImage: Assets.whatsAppIcon.image))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private extension
private extension DetailsView {
    func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }

    func bindActions() {
        
    }

    func setupUI() {
        backgroundColor = .white
    }

    func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(containerStackView)
        
        containerStackView.axis = .vertical
        containerStackView.addArrangedSubview(adsImagesView)
        containerStackView.addArrangedSubview(priceLocationView)
        containerStackView.addArrangedSubview(basicDetailsView)
        containerStackView.addArrangedSubview(socialNetworkView)
        containerStackView.addSpacer()
        
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
        adsImagesView.snp.makeConstraints { $0.height.equalTo(Constant.adsImagesViewHeight) }
    }
}

// MARK: - View constants
private enum Constant {
    static let adsImagesViewHeight: CGFloat = 250
}
