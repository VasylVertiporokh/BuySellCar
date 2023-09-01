//
//  AdvertisementRecommendationView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.03.2023.
//

import UIKit
import SnapKit
import Combine
import SkeletonView

enum AdvertisementRecommendationViewAction {
    case rowSelected(AdvertisementRow)
    case startSearch
}

final class AdvertisementRecommendationView: BaseView {
    // MARK: - Subviews
    private let searchButton = MainButton(type: .startSearch)
    private var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var dataSource: SearchSkeletonDataSource<AdvertisementSection, AdvertisementRow>?
    private var snapShot: NSDiffableDataSourceSnapshot<AdvertisementSection, AdvertisementRow>!
    
    // MARK: - Subjects
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AdvertisementRecommendationViewAction, Never>()
    
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
extension AdvertisementRecommendationView {
    func setupSnapshot(sections: [SectionModel<AdvertisementSection, AdvertisementRow>]) {
        for section in sections {
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(self.snapShot, animatingDifferences: false)
    }
    
    func showSkeleton() {
        collectionView.showAnimatedSkeleton()
    }
    
    func hideSkeleton() {
        collectionView.hideSkeleton()
    }
}

// MARK: - Private extension
private extension AdvertisementRecommendationView {
    func setupDataSource() {
        collectionView.register(cellType: RecommendationCell.self)
        collectionView.register(cellType: QuickSearchCell.self)
        collectionView.register(header: AdvertisementHeaderView.self)
        collectionView.register(view: RecommendationBadgeView.self)
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .recommended(let model):
                let cell: RecommendationCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setInfo(model: model)
                return cell
            case .trending(let model):
                let cell: QuickSearchCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setInfo(model)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self,
                  let dataSource = self.dataSource else { return nil }
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch kind {
            case "UICollectionElementKindSectionHeader":
                let header: AdvertisementHeaderView = collectionView.dequeueSupplementaryView(for: indexPath, kind: kind)
                header.setHeaderTitle(section.headerTitle)
                return header
                
            case "RecommendationBadgeView":
                let badge: RecommendationBadgeView = collectionView.dequeueSupplementaryView(for: indexPath, kind: kind)
                return badge
            default:
                return nil
            }
        }
        
        snapShot = NSDiffableDataSourceSnapshot<AdvertisementSection, AdvertisementRow>()
        snapShot.appendSections([.recommended, .trendingCategories])
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    func initialSetup() {
        setupUI()
        configureCollectionView()
        setupDataSource()
        setupLayout()
        bindActions()
    }
    
    func bindActions() {
        collectionView.didSelectItemPublisher
            .compactMap { self.dataSource?.itemIdentifier(for: $0) }
            .map { AdvertisementRecommendationViewAction.rowSelected($0) }
            .sink { [unowned self] in actionSubject.send($0) }
            .store(in: &cancellables)
        
        searchButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.startSearch) }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        backgroundColor = .white
    }
    
    func setupLayout() {
        addSubview(collectionView)
        addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(Constant.searchButtonHeight)
            $0.leading.equalTo(snp.leading).offset(Constant.defaultSpace)
            $0.trailing.equalTo(snp.trailing).inset(Constant.defaultSpace)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(searchButton.snp.bottom).offset(Constant.defaultSpace)
        }
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.isSkeletonable = true
    }
}

// MARK: - UICollectionView Layout
private extension AdvertisementRecommendationView {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self,
                  let dataSource = self.dataSource else { return nil }
            let sections = dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sections {
            case .recommended:
                return self.recommendedSectionLayout()
                
            case .trendingCategories:
                return self.trendingCategoriesSectionLayout()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Constant.defaultSpace
        
        layout.configuration = config
        return layout
    }
    
    func recommendedSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.recommendationCellHeight)
        )
        
        let badgeViewSize = NSCollectionLayoutSize(
            widthDimension: .estimated(Constant.badgeViewWidth),
            heightDimension: .estimated(Constant.badgeViewHeight)
        )
        let containerAnchor = NSCollectionLayoutAnchor(edges: [.top, .leading], absoluteOffset: Constant.badgeViewOffset)
        let badgeView = NSCollectionLayoutSupplementaryItem(
            layoutSize: badgeViewSize,
            elementKind: String(describing: RecommendationBadgeView.self),
            containerAnchor: containerAnchor
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize, supplementaryItems: [badgeView])
        let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: .zero,
            leading: Constant.defaultSpace,
            bottom: Constant.defaultSpace,
            trailing: Constant.defaultSpace
        )
        section.interGroupSpacing = Constant.defaultSpace
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.headerHeight)
        )
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [headerElement]
        return section
    }
    
    func trendingCategoriesSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute((bounds.width - Constant.allSpacingValue) / Constant.numberOfItemsInGroup),
            heightDimension: .estimated(Constant.trendingCellHeight))
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.trandingGroupHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(Constant.defaultSpace)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: .zero,
            leading: Constant.defaultSpace,
            bottom: .zero,
            trailing: Constant.defaultSpace
        )
        section.interGroupSpacing = Constant.defaultSpace
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.headerHeight)
        )
        
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [headerElement]
        return section
    }
}

// MARK: - View constants
private enum Constant {
    static let trendingCellHeight: CGFloat = 150
    static let fractionalValue: CGFloat = 1.0
    static let defaultSpace: CGFloat = 16
    static let badgeViewOffset: CGPoint = .init(x: 0, y: 15)
    static let searchButtonHeight: CGFloat = 47
    static let allSpacingValue: CGFloat = 48
    static let numberOfItemsInGroup: CGFloat = 2
    static let recommendationCellHeight: CGFloat = 250
    static let badgeViewHeight: CGFloat = 20
    static let badgeViewWidth: CGFloat = 100
    static let headerHeight: CGFloat = 50
    static let trandingGroupHeight: CGFloat = 300
}

// MARK: - Skeleton data source with custom class
private extension AdvertisementRecommendationView {
    // MARK: - SearchSkeletonDataSource
    class SearchSkeletonDataSource<Section: Hashable, Item: Hashable>: UICollectionViewDiffableDataSource<AdvertisementSection, AdvertisementRow> {
        
        // MARK: - Init
        override init(collectionView: UICollectionView, cellProvider: @escaping UICollectionViewDiffableDataSource<AdvertisementSection, AdvertisementRow>.CellProvider) {
            super.init(collectionView: collectionView, cellProvider: cellProvider)
        }
    }
}

// MARK: - SkeletonCollectionViewDataSource
extension AdvertisementRecommendationView.SearchSkeletonDataSource: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        let section = snapshot().sectionIdentifiers[indexPath.section]
        switch section {
        case .trendingCategories:       return QuickSearchCell.className
        case .recommended:              return RecommendationCell.className
        }
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return snapshot().numberOfSections
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = snapshot().sectionIdentifiers[section]
        switch section {
        case .recommended:              return 2
        case .trendingCategories:       return 2
        }
    }
}
