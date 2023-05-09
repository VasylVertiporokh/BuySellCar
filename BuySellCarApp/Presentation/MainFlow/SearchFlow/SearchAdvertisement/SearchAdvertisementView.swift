//
//  SearchAdvertisementView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.04.2023.
//

import UIKit
import SnapKit
import Combine

enum SearchAdvertisementViewAction {
    case rowSelected(SearchRow)
    case deleteSelectedBrands(SearchRow)
    case showAllMakes
}

final class SearchAdvertisementView: BaseView {
    // MARK: - Subviews
    private var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<SearchSection, SearchRow>?
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SearchAdvertisementViewAction, Never>()
    
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
extension SearchAdvertisementView {
    func setupSnapshot(sections: [SectionModel<SearchSection, SearchRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<SearchSection, SearchRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot)
    }
}

// MARK: - Private extension
private extension SearchAdvertisementView {
    func initialSetup() {
        configureCollectionView()
        setupLayout()
        setupDataSource()
        setupUI()
        bindActions()
    }
    
    func bindActions() {
        collectionView.didSelectItemPublisher
            .compactMap { self.dataSource?.itemIdentifier(for: $0) }
            .map { SearchAdvertisementViewAction.rowSelected($0) }
            .sink { [unowned self] in actionSubject.send($0) }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        backgroundColor = .white
    }
    
    func setupLayout() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemGroupedBackground
    }
}

// MARK: - Configure layout
private extension SearchAdvertisementView {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self,
                  let dataSource = self.dataSource else { return nil }
            
            let sections = dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sections {
            case .brands:                            return self.brandsSectionLayout()
            case .selectedBrand(let isAvailable):    return self.selectedBrandSectionLayout(isAvailable)
            case .bodyType:                          return self.bodyTypesSectionLayout()
            case .fuelType:                          return self.fuelTypeSectionLayout()
            case .transmissionType:                  return self.transmissionTypeSectionLayout()
            case .sellerInfo:                        return self.sellerInfoSectionLayout()
            case .firstRegistration:                 return self.technicalSpecSection()
            case .millage:                           return self.technicalSpecSection()
            case .power:                             return self.technicalSpecSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Constant.interSectionSpacing
        layout.configuration = config
        return layout
    }
    
    func brandsSectionLayout() -> NSCollectionLayoutSection {
        let itemLayout = NSCollectionLayoutSize(
            widthDimension: .absolute((bounds.width - Constant.carBrandGroupInsets) / Constant.numberOfItemsInBrandGroup),
            heightDimension: .absolute((bounds.width - Constant.carBrandGroupInsets) / Constant.numberOfItemsInBrandGroup)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.trandingGroupHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayout)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = Constant.brandGroupInset
        
        let backgroundDecorationView = NSCollectionLayoutDecorationItem.background(
            elementKind: DecorationGroupView.className
        )
        backgroundDecorationView.contentInsets.top = Constant.backgroundDecorationTopInset
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.headerHeight)
        )
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SearchSectionHeaderView.className,
            alignment: .top
        )
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.headerHeight)
        )
        
        let footerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: BrandsFooterView.className,
            alignment: .bottom
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerElement, footerElement]
        section.decorationItems = [backgroundDecorationView]
        section.interGroupSpacing = Constant.defaultSpace
        return section
    }
    
    func selectedBrandSectionLayout(_ isAddingAvailable: Bool) -> NSCollectionLayoutSection {
        let itemLayout = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .absolute(Constant.headerHeight)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.trandingGroupHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayout)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.headerHeight)
        )
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SearchSectionHeaderView.className,
            alignment: .top
        )
        
        let backgroundDecorationView = NSCollectionLayoutDecorationItem.background(
            elementKind: DecorationGroupView.className
        )
        backgroundDecorationView.contentInsets.top = Constant.backgroundDecorationTopInset
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.headerHeight)
        )
        
        let footerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: BrandsFooterView.className,
            alignment: .bottom
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.decorationItems = [backgroundDecorationView]
        section.boundarySupplementaryItems = isAddingAvailable ? [headerElement, footerElement] : [headerElement]
        return section
    }
    
    func bodyTypesSectionLayout() -> NSCollectionLayoutSection {
        let itemLayout = NSCollectionLayoutSize(
            widthDimension: .absolute((bounds.width - Constant.bodyTypeGroupInsets) / Constant.numberOfItemsInBrandGroup),
            heightDimension: .absolute((bounds.width - Constant.bodyTypeGroupInsets) / Constant.numberOfItemsInBrandGroup)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.trandingGroupHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayout)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.contentInsets = Constant.brandGroupInset
        group.interItemSpacing = .fixed(Constant.defaultSpace)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.headerHeight)
        )
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SearchSectionHeaderView.className,
            alignment: .top
        )
        
        let backgroundDecorationView = NSCollectionLayoutDecorationItem.background(
            elementKind: DecorationGroupView.className
        )
        backgroundDecorationView.contentInsets.top = Constant.backgroundDecorationTopInset
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = Constant.bodyTypesSectionInset
        section.decorationItems = [backgroundDecorationView]
        section.boundarySupplementaryItems = [headerElement]
        section.interGroupSpacing = Constant.defaultSpace
        return section
    }
    
    func fuelTypeSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(Constant.additionalParamCellWidth),
            heightDimension: .absolute(Constant.additionalParamCellHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(Constant.fuelTypeGroupWidth),
            heightDimension: .absolute(Constant.additionalParamCellHeight)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.headerHeight)
        )
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SearchSectionHeaderView.className,
            alignment: .top
        )
        headerElement.contentInsets.leading = Constant.fuelTypeHeaderInset
        
        let backgroundDecorationView = NSCollectionLayoutDecorationItem.background(
            elementKind: DecorationGroupView.className
        )
        
        backgroundDecorationView.contentInsets.top = Constant.backgroundDecorationTopInset
        
        let section = NSCollectionLayoutSection(group: group)
        section.decorationItems = [backgroundDecorationView]
        section.boundarySupplementaryItems = [headerElement]
        section.contentInsets = Constant.fuelTypeSectionInset
        section.interGroupSpacing = Constant.interSectionSpacing
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func technicalSpecSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.technicalSpecSectionHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.technicalSpecSectionHeight)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.headerHeight)
        )
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SearchSectionHeaderView.className,
            alignment: .top
        )
        headerElement.contentInsets.leading = Constant.fuelTypeHeaderInset
        
        let backgroundDecorationView = NSCollectionLayoutDecorationItem.background(
            elementKind: DecorationGroupView.className
        )
        
        backgroundDecorationView.contentInsets.top = Constant.backgroundDecorationTopInset
        
        let section = NSCollectionLayoutSection(group: group)
        section.decorationItems = [backgroundDecorationView]
        section.boundarySupplementaryItems = [headerElement]
        section.contentInsets = Constant.fuelTypeSectionInset
        return section
    }
    
    func transmissionTypeSectionLayout() -> NSCollectionLayoutSection {
        let itemLayout = NSCollectionLayoutSize(
            widthDimension: .absolute((bounds.width - Constant.transmissionTypeInsets) / Constant.transmissionTypeCount),
            heightDimension: .absolute(Constant.additionalParamCellHeight)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.additionalParamCellHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayout)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = .fixed(Constant.defaultSpace)
        group.contentInsets = Constant.transmissionTypeGroupInset
        
        let backgroundDecorationView = NSCollectionLayoutDecorationItem.background(
            elementKind: DecorationGroupView.className
        )
        
        backgroundDecorationView.contentInsets.top = Constant.backgroundDecorationTopInset
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.headerHeight)
        )
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SearchSectionHeaderView.className,
            alignment: .top
        )
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerElement]
        section.decorationItems = [backgroundDecorationView]
        section.contentInsets = Constant.transmissionTypeSectionInset
        return section
    }
    
    func sellerInfoSectionLayout() -> NSCollectionLayoutSection {
        let itemLayout = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .absolute(Constant.sellerInfoCellHeight)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.sellerInfoGroupHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayout)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.headerHeight)
        )
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SearchSectionHeaderView.className,
            alignment: .top
        )
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerElement]
        return section
    }
}

// MARK: - Setup data source
private extension SearchAdvertisementView {
    func setupDataSource() {
        collectionView.register(cellType: BrandCell.self)
        collectionView.register(cellType: BodyTypeCell.self)
        collectionView.register(view: BrandsFooterView.self)
        collectionView.register(view: SearchSectionHeaderView.self)
        collectionView.register(cellType: AdditionalSearchParamCell.self)
        collectionView.register(cellType: TechnicalSpecCell.self)
        collectionView.register(cellType: SearchPlainCell.self)
        collectionView.register(cellType: SelectedBrandCell.self)
        collectionView.collectionViewLayout.register(decoration: DecorationGroupView.self)
        
        dataSource = .init(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, item in
            switch item {
            case .brandsRow(let brandModel):
                let cell: BrandCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setData(brandModel)
                return cell
            case .selectedBrandRow(let selectedBrandModel):
                let cell: SelectedBrandCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setBrand(selectedBrandModel)
                cell.deleteTapped = { [weak self] in self?.actionSubject.send(.deleteSelectedBrands(item)) }
                return cell
            case .bodyTypeRow(let bodyModel):
                let cell: BodyTypeCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setData(bodyModel)
                return cell
            case .fuelTypeRow(let fuelType):
                let cell: AdditionalSearchParamCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setFuelType(fuelType)
                return cell
            case .transmissionTypeRow(let transmissionType):
                let cell: AdditionalSearchParamCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setTransmissionType(transmissionType)
                return cell
            case .seller(let title):
                let cell: SearchPlainCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setLabelText(title)
                return cell
            case .location(let title):
                let cell: SearchPlainCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setLabelText(title)
                return cell
            case .firstRegistrationRow(let dataModel):
                let cell: TechnicalSpecCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setDataModel(dataModel)
                return cell
            case .millageRow(let dataModel):
                let cell: TechnicalSpecCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setDataModel(dataModel)
                return cell
            case .powerRow(let dataModel):
                let cell: TechnicalSpecCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setDataModel(dataModel)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self,
                  let dataSource = self.dataSource else { return nil }
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch kind {
            case BrandsFooterView.className:
                let footer: BrandsFooterView = collectionView.dequeueSupplementaryView(for: indexPath, kind: kind)
                footer.showMore = { [weak self] in
                    self?.actionSubject.send(.showAllMakes)
                }
                return footer

            case SearchSectionHeaderView.className:
                let header: SearchSectionHeaderView = collectionView.dequeueSupplementaryView(for: indexPath, kind: kind)
                header.setHeaderTitle(section.sectionHeaderTitle)
                return header
            default:
                return nil
            }
        }
    }
}

// MARK: - View constants
private enum Constant {
    static let transmissionTypeCount: CGFloat = 3
    static let interSectionSpacing: CGFloat = 8
    static let backgroundDecorationTopInset: CGFloat = 32
    static let fractionalValue: CGFloat = 1.0
    static let defaultSpace: CGFloat = 4
    static let carBrandGroupInsets: CGFloat = 40
    static let transmissionTypeInsets: CGFloat = 40
    static let bodyTypeGroupInsets: CGFloat = 52
    static let numberOfItemsInBrandGroup: CGFloat = 4
    static let headerHeight: CGFloat = 50
    static let trandingGroupHeight: CGFloat = 250
    static let additionalParamCellHeight: CGFloat = 30
    static let additionalParamCellWidth: CGFloat = 100
    static let fuelTypeGroupWidth: CGFloat = 450
    static let technicalSpecSectionHeight: CGFloat = 180
    static let fuelTypeHeaderInset: CGFloat = -16
    static let sellerInfoGroupHeight: CGFloat = 70
    static let sellerInfoCellHeight: CGFloat = 35
    static let transmissionTypeGroupInset: NSDirectionalEdgeInsets = .init(top: .zero, leading: 16, bottom: .zero, trailing: 16)
    static let brandGroupInset: NSDirectionalEdgeInsets = .init(top: .zero, leading: 20, bottom: .zero, trailing: 20)
    static let bodyTypesSectionInset: NSDirectionalEdgeInsets = .init(top: 16, leading: .zero, bottom: 16, trailing: .zero)
    static let fuelTypeSectionInset: NSDirectionalEdgeInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
    static let transmissionTypeSectionInset: NSDirectionalEdgeInsets = .init(top: 8, leading: .zero, bottom: 8, trailing: .zero)
}











//Section
enum SearchSection: Hashable {
    case brands
    case selectedBrand(isAddAvailable: Bool)
    case bodyType
    case fuelType
    case firstRegistration
    case millage
    case power
    case transmissionType
    case sellerInfo
}

enum SearchRow: Hashable {
    case brandsRow(BrandCellModel)
    case selectedBrandRow(SelectedBrandModel)
    case bodyTypeRow(BodyTypeCellModel)
    case fuelTypeRow(FuelTypeModel)
    case firstRegistrationRow(TechnicalSpecCellModel)
    case millageRow(TechnicalSpecCellModel)
    case powerRow(TechnicalSpecCellModel)
    case transmissionTypeRow(TransmissionTypeModel)
    case seller(String)
    case location(String)
}

// MARK: - Internal extension
extension SearchSection {
    var sectionHeaderTitle: String {
        switch self {
        case .brands, .selectedBrand:   return "MAKE & MODEL"
        case .bodyType:                 return "BODY TYPE"
        case .fuelType:                 return "FUEL TYPE"
        case .firstRegistration:        return "FIRST REGISTRATION"
        case .millage:                  return "MILLAGE"
        case .power:                    return "POWER"
        case .transmissionType:         return "TRANSMISSION"
        case .sellerInfo:               return "SELLER, LOCATION"
        }
    }
}

struct BrandCellModel: Hashable {
    let logoImage: UIImage
    let brandName: String
    
    static func basicBrands() -> [Self] {
        return [
            .init(logoImage: Assets.bmwLogo.image, brandName: "BMW"),
            .init(logoImage: Assets.volkswagenLogo.image, brandName: "Volkswagen"),
            .init(logoImage: Assets.audiLogo.image, brandName: "Audi"),
            .init(logoImage: Assets.mercedesLogo.image, brandName: "Mercedes"),
            .init(logoImage: Assets.fordLogo.image, brandName: "Ford"),
            .init(logoImage: Assets.fiatLogo.image, brandName: "Fiat"),
            .init(logoImage: Assets.renaultLogo.image, brandName: "Renault"),
            .init(logoImage: Assets.fiatLogo.image, brandName: "Nissan")
        ]
    }
    
}

struct BodyTypeCellModel: Hashable {
    let bodyTypeImage: UIImage
    let bodyTypeLabel: String
    var isSelected: Bool = false
    
    static func basicBodyTypes() -> [Self] {
        return [
            .init(bodyTypeImage: Assets.compactBody.image, bodyTypeLabel: "Compact"),
            .init(bodyTypeImage: Assets.sedanBody.image, bodyTypeLabel: "Sedan"),
            .init(bodyTypeImage: Assets.stationWagonBody.image, bodyTypeLabel: "Station wagon"),
            .init(bodyTypeImage: Assets.cabrioBody.image, bodyTypeLabel: "Cabrio"),
            .init(bodyTypeImage: Assets.suvBody.image, bodyTypeLabel: "SUV"),
            .init(bodyTypeImage: Assets.vanBody.image, bodyTypeLabel: "Van"),
            .init(bodyTypeImage: Assets.transporterBody.image, bodyTypeLabel: "Transporter"),
            .init(bodyTypeImage: Assets.hatchbackBody.image, bodyTypeLabel: "Hatchback")
        ]
    }
}

struct FuelTypeModel: Hashable {
    let fuelType: String
    var isSelected: Bool = false
    
    static func fuelTypes() -> [Self] {
        return [
            .init(fuelType: "Petrol"),
            .init(fuelType: "Electric"),
            .init(fuelType: "Hybrid"),
            .init(fuelType: "Diesel"),
            .init(fuelType: "LPG"),
            .init(fuelType: "Ethanol"),
            .init(fuelType: "Hydrogen"),
            .init(fuelType: "Other")
        ]
    }
}

struct TransmissionTypeModel: Hashable {
    let transmissionType: String
    var isSelected: Bool = false
    
    static func transmissionTypes() -> [Self] {
        return [
            .init(transmissionType: "Manual"),
            .init(transmissionType: "Automatic"),
            .init(transmissionType: "Semi-automatic")
        ]
    }
}

struct SellerDetails: Hashable {
    let cellTitle: String
}

struct SelectedBrandModel: Hashable {
    let brand: String
    var model: String?
}

struct TechnicalSpecCellModel {
    // MARK: - Nested entity
    struct SelectedRange: Hashable {
        var minRangeValue: Double?
        var maxRangeValue: Double?
    }
    
    // MARK: - Properties
    private let uuid = UUID().uuidString
    let inRange: RangeView.Range
    let rangeStep: Double
    let selectedRange: CurrentValueSubject<SelectedRange, Never>
    
    var newRange: RangeView.Range {
        return .init(
            lowerBound: selectedRange.value.minRangeValue ?? inRange.lowerBound,
            upperBound: selectedRange.value.maxRangeValue ?? inRange.upperBound
        )
    }
    
    // MARK: - TechnicalSpecCell models
    static func year(selectedRange: CurrentValueSubject<SelectedRange, Never>) -> SectionModel<SearchSection, SearchRow> {
        let year = Calendar.current.component(.year, from: Date())
        let yearRange: RangeView.Range = .init(lowerBound: 1920, upperBound: Double(year))
        
        return .init(section: .firstRegistration, items: [
            .firstRegistrationRow(.init(inRange: yearRange, rangeStep: 1, selectedRange: selectedRange))])
    }
    
    static func millage(selectedRange: CurrentValueSubject<SelectedRange, Never>) -> SectionModel<SearchSection, SearchRow> {
        let millageRange: RangeView.Range = .init(lowerBound: 0, upperBound: 250000)
        
        return .init(section: .millage, items: [
            .millageRow(.init(inRange: millageRange, rangeStep: 500, selectedRange: selectedRange))])
    }
    
    static func power(selectedRange: CurrentValueSubject<SelectedRange, Never>) -> SectionModel<SearchSection, SearchRow> {
        let powerRange: RangeView.Range = .init(lowerBound: 20, upperBound: 1000)
        
        return .init(section: .power, items: [
            .powerRow(.init(inRange: powerRange, rangeStep: 10, selectedRange: selectedRange))])
    }
}

// MARK: - Conform to Hashable
extension TechnicalSpecCellModel: Hashable {
    static func == (lhs: TechnicalSpecCellModel, rhs: TechnicalSpecCellModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
