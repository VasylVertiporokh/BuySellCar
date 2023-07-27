//
//  SearchResultView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 29.03.2023.
//

import UIKit
import SnapKit
import Combine

enum SearchResultViewAction {
    case showSearch
    case deleteBrandTapped(SelectedBrandModel)
    case deleteModelTapped(ModelCellConfigurationModel)
    case deleteBodyTapped(BodyTypeModel)
    case deleteFuelTypeTapped(FuelTypeModel)
    case deleteTransmissionTypeTapped(TransmissionTypeModel)
    case deleteRegistrationTapped(SearchParam)
    case deleteMillageTapped(SearchParam)
    case deletePowerTapped(SearchParam)
    case needLoadNextPage(Bool)
}

final class SearchResultView: BaseView {
    // MARK: - Subviews
    private var collectionView: UICollectionView!
    private let filterView = FilterView()
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<AdvertisementSearchResultSection, AdvertisementResultRow>?
    private var isPaging: Bool = false
    
    // MARK: - Subjects
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SearchResultViewAction, Never>()
    
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
extension SearchResultView {
    func setupSnapshot(sections: [SectionModel<AdvertisementSearchResultSection, AdvertisementResultRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<AdvertisementSearchResultSection, AdvertisementResultRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
    
    func setupSearchSnapshot(sections: [SectionModel<SelectedFilterSection, SelectedFilterRow>]) {
        filterView.setupSnapshot(sections: sections)
    }
    
    func setPagingState(_ isPaging: Bool) {
        self.isPaging = isPaging
    }
}

// MARK: - Private extension
private extension SearchResultView {
    func initialSetup() {
        setupUI()
        configureCollectionView()
        setupDataSource()
        setupLayout()
        bindActions()
    }
    
    func bindActions() {
        filterView.filterViewActionAction
            .sink { [unowned self] action in
                switch action {
                case .showFilters:                                 actionSubject.send(.showSearch)
                case .deleteBrandTapped(let brand):                actionSubject.send(.deleteBrandTapped(brand))
                case .deleteModelTapped(let model):                actionSubject.send(.deleteModelTapped(.init(brandDomainModel: model)))
                case .deleteBodyTapped(let bodyType):              actionSubject.send(.deleteBodyTapped(bodyType))
                case .deleteFuelTypeTapped(let fuelType):          actionSubject.send(.deleteFuelTypeTapped(fuelType))
                case .deleteRegistrationTapped(let registration):  actionSubject.send(.deleteRegistrationTapped(registration))
                case .deleteMillageTapped(let millage):            actionSubject.send(.deleteMillageTapped(millage))
                case .deletePowerTapped(let power):                actionSubject.send(.deletePowerTapped(power))
                case .deleteTransmissionTapped(let transmission):  actionSubject.send(.deleteTransmissionTypeTapped(transmission))
                }
            }
            .store(in: &cancellables)
        
        collectionView.reachedBottomPublisher()
            .sink { [unowned self] _ in
                actionSubject.send(.needLoadNextPage(true))
            }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        backgroundColor = .white
        filterView.dropShadow(
            shadowColor: Colors.buttonDarkGray.color,
            shadowOffset: .init(width: 0, height: 4),
            shadowOpacity: 0.2,
            shadowRadius: 4
        )
    }
    
    func setupLayout() {
        addSubview(filterView)
        filterView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(snp.leading)
            $0.trailing.equalTo(snp.trailing)
            $0.height.equalTo(Constant.filterViewHeight)
        }
    }
}

// MARK: - Collection view configuration
private extension SearchResultView {
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalTo(snp.edges) }
    }
    
    func setupDataSource() {
        collectionView.register(cellType: SearchResultCell.self)
        collectionView.register(footer: LoaderFooterView.self)
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .searchResultRow(let model):
                let cell: SearchResultCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setInfo(model)
                guard let carRow = self.dataSource?.itemIdentifier(for: indexPath) else { return cell }
                cell.setupSnapshot(sections: [
                    .init(section: .images, items: carRow.carImages.map { CarImageRow.carImage($0) })
                ])
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self,
                  let dataSource = self.dataSource else { return nil }
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch section {
            case .searchResult:
                let header: LoaderFooterView = collectionView.dequeueSupplementaryView(for: indexPath, kind: kind)
                header.startAnimating()
                return header
            }
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self,
                  let dataSource = self.dataSource else { return nil }
            
            let sections = dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sections {
            case .searchResult:
                return self.resultSectionLayout()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Constant.defaultSpace
        
        layout.configuration = config
        return layout
    }
    
    func resultSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.resultCellHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constant.sectionTopInset,
            leading: Constant.defaultSpace,
            bottom: Constant.defaultSpace,
            trailing: Constant.defaultSpace
        )
        section.interGroupSpacing = Constant.defaultSpace
        
        // TODO: - Fix after demo
//        let footerSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(Constant.fractionalValue),
//            heightDimension: .estimated(30)
//        )
//
//        let footerElement = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: footerSize,
//            elementKind: UICollectionView.elementKindSectionFooter,
//            alignment: .bottom
//        )
//        section.boundarySupplementaryItems = [footerElement]
        
        return section
    }
}

// MARK: - View constants
private enum Constant {
    static let resultCellHeight: CGFloat = 350
    static let fractionalValue: CGFloat = 1.0
    static let defaultSpace: CGFloat = 16
    static let sectionTopInset: CGFloat = 66
    static let badgeViewOffset: CGPoint = .init(x: 0, y: 15)
    static let searchButtonHeight: CGFloat = 47
    static let allSpacingValue: CGFloat = 48
    static let numberOfItemsInGroup: CGFloat = 2
    static let filterViewHeight: CGFloat = 50
}
