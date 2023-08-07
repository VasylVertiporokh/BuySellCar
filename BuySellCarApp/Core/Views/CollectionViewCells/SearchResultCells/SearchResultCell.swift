//
//  SearchResultCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.03.2023.
//

import UIKit
import SnapKit

final class SearchResultCell: UICollectionViewCell {
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<CarImageSection, CarImageRow>?
    
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let carInformationStackView = UIStackView()
    private let collectionContainerStackView = UIStackView()
    private let counterLabel = UILabel()
    private let mainInfoStackView = UIStackView()
    private let modelNameStackView = UIStackView()
    private let modelNameLabel = UILabel()
    private let priceLabel = UILabel()
    private let shareButton = UIButton(type: .system)
    private let carDetailsStackView = UIStackView()
    private let leftInfoStackView = UIStackView()
    private let rightInfoStackView = UIStackView()
    private let mileageLabel = UILabel()
    private let powerLabel = UILabel()
    private let numberOfOwners = UILabel()
    private let fuelConsumptionLabel = UILabel()
    private let yearLabel = UILabel()
    private let conditionLabel = UILabel()
    private let fuelTypeLabel = UILabel()
    private let colorLabel = UILabel()
    private let separatorView = UIView()
    private let sellerStackView = UIStackView()
    private let sellerNameLabel = UILabel()
    private let locationLabel = UILabel()
    private var carImageCollectionView: UICollectionView!
    
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
        setShadow()
    }
}

// MARK: - Internal extension
extension SearchResultCell {
    func setInfo(_ model: AdvertisementCellModel) {
        modelNameLabel.text = "\(model.brandName) \(model.brandModel)"
        priceLabel.text = "€ \("\(model.price)".toSimpleNumberFormat()).-"
        mileageLabel.text = "\("\(model.mileage)".toSimpleNumberFormat()) km"
        powerLabel.text = "\("\(model.power)".toSimpleNumberFormat()) hp"
        numberOfOwners.text = "\(Int.random(in: 1...5)) previous owners"
        fuelConsumptionLabel.text = "\(model.fuelConsumption) L/100 km (comb)*"
        yearLabel.text = String(model.year)
        conditionLabel.text = model.condition
        fuelTypeLabel.text = model.fuelType
        colorLabel.text = model.color
        sellerNameLabel.text = model.sellerName
        locationLabel.text = model.location
    }
    
    func setupSnapshot(sections: [SectionModel<CarImageSection, CarImageRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<CarImageSection, CarImageRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot)
    }
}

// MARK: - Private extensions
private extension SearchResultCell {
    func initialSetup() {
        configureStackViews()
        configureCollectionView()
        setupDataSource()
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(collectionContainerStackView)
        collectionContainerStackView.addArrangedSubview(carImageCollectionView)
        containerStackView.addArrangedSubview(carInformationStackView)
        carInformationStackView.addArrangedSubview(mainInfoStackView)
        mainInfoStackView.addArrangedSubview(modelNameStackView)
        modelNameStackView.addArrangedSubview(modelNameLabel)
        modelNameStackView.addArrangedSubview(shareButton)
        mainInfoStackView.addArrangedSubview(priceLabel)
        carInformationStackView.addArrangedSubview(carDetailsStackView)
        carDetailsStackView.addArrangedSubview(leftInfoStackView)
        leftInfoStackView.addArrangedSubview(mileageLabel)
        leftInfoStackView.addArrangedSubview(powerLabel)
        leftInfoStackView.addArrangedSubview(numberOfOwners)
        leftInfoStackView.addArrangedSubview(fuelConsumptionLabel)
        carDetailsStackView.addArrangedSubview(rightInfoStackView)
        rightInfoStackView.addArrangedSubview(yearLabel)
        rightInfoStackView.addArrangedSubview(conditionLabel)
        rightInfoStackView.addArrangedSubview(fuelTypeLabel)
        rightInfoStackView.addArrangedSubview(colorLabel)
        carInformationStackView.addArrangedSubview(separatorView)
        carInformationStackView.addArrangedSubview(sellerStackView)
        sellerStackView.addArrangedSubview(sellerNameLabel)
        sellerStackView.addArrangedSubview(locationLabel)
        collectionContainerStackView.addSubview(counterLabel)
        
        carInformationStackView.isLayoutMarginsRelativeArrangement = true
        carInformationStackView.layoutMargins = Constant.carInformationStackMargins
        modelNameStackView.isLayoutMarginsRelativeArrangement = true
        modelNameStackView.layoutMargins = Constant.modelNameStackViewMargins
        
        collectionContainerStackView.snp.makeConstraints { $0.height.equalTo(Constant.collectionContainerViewHeight) }
        containerStackView.snp.makeConstraints { $0.edges.equalTo(contentView.snp.edges) }
        shareButton.snp.makeConstraints { $0.height.width.equalTo(Constant.shareButtonConstraint) }
        separatorView.snp.makeConstraints { $0.height.equalTo(Constant.separatorViewHeight) }
        counterLabel.snp.makeConstraints {
            $0.leading.equalTo(collectionContainerStackView.snp.leading).offset(Constant.counterLabelConstraint)
            $0.bottom.equalTo(collectionContainerStackView.snp.bottom).inset(Constant.counterLabelConstraint)
            $0.width.equalTo(Constant.counterLabelWidth)
            $0.height.equalTo(Constant.counterLabelHeight)
        }
    }
    
    func setupUI() {
        configureLabels()
        collectionContainerStackView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collectionContainerStackView.layer.cornerRadius = Constant.mainCornerRadius
        carImageCollectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        carImageCollectionView.layer.cornerRadius = Constant.mainCornerRadius
        
        separatorView.backgroundColor = .lightGray
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.isHidden = true
    }
    
    func setShadow() {
        layer.cornerRadius = Constant.mainCornerRadius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = Constant.shadowOffset
        layer.shadowOpacity = Constant.shadowOpacity
        layer.shadowRadius = Constant.mainCornerRadius
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constant.mainCornerRadius
        
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: Constant.mainCornerRadius
        ).cgPath
    }
}

// MARK: - Configure collection view
private extension SearchResultCell {
    func configureCollectionView() {
        carImageCollectionView = .init(
            frame: collectionContainerStackView.bounds,
            collectionViewLayout: createLayout()
        )
        carImageCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setupDataSource() {
        carImageCollectionView.register(cellType: CarImageCell.self)
        dataSource = .init(collectionView: carImageCollectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .carImage(let model):
                let cell: CarImageCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setImageURL(model)
                return cell
            }
        })
    }
    
    func setNumberOfPages(pageNumber: Int) {
        guard let itemCount = dataSource?.snapshot().numberOfItems(inSection: .images) else {
            counterLabel.isHidden = true
            return
        }
        counterLabel.isHidden = itemCount.isEquallyOne
        counterLabel.text = "\(pageNumber.incrementByOne)/\(itemCount)"
    }
        
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self,
                  let dataSource = self.dataSource else { return nil }

            let sections = dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sections {
            case .images:
                return self.resultSectionLayout()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func resultSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.collectionViewLayoutSize),
            heightDimension: .fractionalHeight(Constant.collectionViewLayoutSize)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.collectionViewLayoutSize),
            heightDimension: .fractionalHeight(Constant.collectionViewLayoutSize)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        section.visibleItemsInvalidationHandler = { [weak self] (items, offset, _) -> Void in
            guard let self = self else { return }
            let page = offset.x / self.bounds.width
            self.setNumberOfPages(pageNumber: Int(round(page)))
        }
        return section
    }
}

// MARK: - Configure stack views
private extension SearchResultCell {
    func configureStackViews() {
        containerStackView.axis = .vertical
        containerStackView.spacing = Constant.middleSpacing
        
        carInformationStackView.axis = .vertical
        carInformationStackView.spacing = Constant.middleSpacing
        
        mainInfoStackView.axis = .vertical
        mainInfoStackView.distribution = .fill
        mainInfoStackView.spacing = Constant.minSpacing
        
        modelNameStackView.axis = .horizontal
        modelNameStackView.alignment = .center
        modelNameStackView.spacing = Constant.maxSpacing
        
        carDetailsStackView.axis = .horizontal
        carDetailsStackView.spacing = Constant.maxSpacing
        carDetailsStackView.distribution = .fillEqually
        
        leftInfoStackView.axis = .vertical
        leftInfoStackView.spacing = Constant.minSpacing
        leftInfoStackView.distribution = .fillEqually
        
        rightInfoStackView.axis = .vertical
        rightInfoStackView.spacing = Constant.minSpacing
        rightInfoStackView.distribution = .fillEqually
        
        sellerStackView.axis = .vertical
        sellerStackView.spacing = Constant.minSpacing
        sellerStackView.distribution = .fillProportionally
    }
    
    func configureLabels() {
        [
            mileageLabel,
            powerLabel,
            numberOfOwners,
            fuelConsumptionLabel,
            yearLabel,
            conditionLabel,
            fuelTypeLabel,
            colorLabel,
            sellerNameLabel,
            locationLabel
        ].forEach {
            $0.textColor = .black
            $0.font = Constant.defaultLabelFont
        }
        priceLabel.font = Constant.priceLabelFont
        modelNameLabel.font = Constant.modelNameFont
        modelNameLabel.numberOfLines = Constant.modelNameLabelLines
        
        counterLabel.textAlignment = .center
        counterLabel.backgroundColor = Colors.buttonDarkGray.color
        counterLabel.layer.borderWidth = Constant.counterLabelBorderWidth
        counterLabel.layer.borderColor = UIColor.white.cgColor
        counterLabel.layer.cornerRadius = Constant.counterLabelRadius
        counterLabel.clipsToBounds = true
        counterLabel.textColor = .white
        counterLabel.font = Constant.counterLabelFont
    }
}

// MARK: - Constant
private enum Constant {
    static let carInformationStackMargins: UIEdgeInsets = .init(top: .zero, left: 16, bottom: 8, right: 16)
    static let modelNameStackViewMargins: UIEdgeInsets = .init(top: .zero, left: .zero, bottom: .zero, right: 16)
    static let mainCornerRadius: CGFloat = 8
    static let shadowOpacity: Float = 0.5
    static let shadowOffset = CGSize(width: .zero, height: 10)
    static let maxSpacing: CGFloat = 32
    static let middleSpacing: CGFloat = 8
    static let minSpacing: CGFloat = 4
    static let collectionViewLayoutSize: CGFloat = 1.0
    static let defaultLabelFont: UIFont = FontFamily.Montserrat.regular.font(size: 14)
    static let priceLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 20)
    static let modelNameFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 16)
    static let counterLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 10)
    static let modelNameLabelLines: Int = 2
    static let collectionContainerViewHeight: CGFloat = 220
    static let counterLabelBorderWidth: CGFloat = 0.5
    static let counterLabelRadius: CGFloat = 4
    static let counterLabelConstraint: CGFloat = 8
    static let separatorViewHeight: CGFloat = 0.5
    static let shareButtonConstraint: CGFloat = 25
    static let counterLabelHeight: CGFloat = 20
    static let counterLabelWidth: CGFloat = 30
}
