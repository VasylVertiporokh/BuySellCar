//
//  AdvertisementRecommendationView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.03.2023.
//

import UIKit
import SnapKit
import Combine

enum AdvertisementRecommendationViewAction {
    case rowSelected(AdvertisementRow)
    case startSearch
}

final class AdvertisementRecommendationView: BaseView {
    // MARK: - Subviews
    private let searchButton = MainButton(type: .startSearch)
    private var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<AdvertisementSection, AdvertisementRow>?
    
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
        var snapShot = NSDiffableDataSourceSnapshot<AdvertisementSection, AdvertisementRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot)
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
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
            case "UICollectionElementKindSectionHeader":
                let header: AdvertisementHeaderView = collectionView.dequeueSupplementaryView(for: indexPath, kind: kind)
                guard let sectionType = AdvertisementSection(rawValue: indexPath.section) else {
                    fatalError()
                }
                header.setHeaderTitle(sectionType.headerTitle)
                return header
            case "RecommendationBadgeView":
                let badge: RecommendationBadgeView = collectionView.dequeueSupplementaryView(for: indexPath, kind: kind)
                return badge
            default:
                return nil
            }
        }
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
    }
}

// MARK: - UICollectionView Layout
private extension AdvertisementRecommendationView {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [unowned self] sectionIndex, layoutEnvironment in
            guard let sectionType = AdvertisementSection(rawValue: sectionIndex) else { fatalError() }
            switch sectionType {
            case .recommended:
                return recommendedSectionLayout()
            case .trendingCategories:
                return trendingCategoriesSectionLayout()
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
            heightDimension: .estimated(Constant.estimatedValue)
        )
        
        let badgeViewSize = NSCollectionLayoutSize(
            widthDimension: .estimated(Constant.estimatedValue),
            heightDimension: .estimated(Constant.estimatedValue)
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
            heightDimension: .estimated(Constant.estimatedValue)
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
            heightDimension: .estimated(Constant.estimatedValue)
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.fractionalValue),
            heightDimension: .estimated(Constant.estimatedValue))
        
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
            heightDimension: .estimated(Constant.estimatedValue)
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
    static let estimatedValue: CGFloat = 1
    static let fractionalValue: CGFloat = 1.0
    static let defaultSpace: CGFloat = 16
    static let badgeViewOffset: CGPoint = .init(x: 0, y: 15)
    static let searchButtonHeight: CGFloat = 47
    static let allSpacingValue: CGFloat = 48
    static let numberOfItemsInGroup: CGFloat = 2
}
