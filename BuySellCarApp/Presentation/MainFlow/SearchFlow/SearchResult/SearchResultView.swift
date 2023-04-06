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
    case deleteSearchParam(SearchParam)
}

final class SearchResultView: BaseView {
    // MARK: - Subviews
    private var collectionView: UICollectionView!
    private let filterView = FilterView()
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<AdvertisementSearchResultSection, AdvertisementResultRow>?

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

    private func initialSetup() {
        setupUI()
        configureCollectionView()
        setupDataSource()
        setupLayout()
        bindActions()
    }

    private func bindActions() {
        filterView.filterViewActionAction
            .sink { [unowned self] action in
                switch action {
                case .deleteSearchParam(let param):
                    actionSubject.send(.deleteSearchParam(param))
                }
            }
            .store(in: &cancellables)
    }

    private func setupUI() {
        backgroundColor = .white
        filterView.dropShadow(
            shadowColor: Colors.buttonDarkGray.color,
            shadowOffset: .init(width: 0, height: 4),
            shadowOpacity: 0.2,
            shadowRadius: 4
        )
    }

    private func setupLayout() {
        addSubview(filterView)
        filterView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(snp.leading)
            $0.trailing.equalTo(snp.trailing)
            $0.height.equalTo(50)
        }
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
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    func setupSearchSnapshot(sections: [SectionModel<FilteredSection, FilteredRow>]) {
        filterView.setupSnapshot(sections: sections)
    }
}

private extension SearchResultView {
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalTo(snp.edges) }
    }
    
    func setupDataSource() {
        collectionView.register(cellType: SearchResultCell.self)
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .searchResultRow(let model):
                let cell: SearchResultCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setInfo(model)
                guard let carRow = self.dataSource?.itemIdentifier(for: indexPath) else { return cell }
                cell.setupSnapshot(sections: [
                    .init(section: .images, items: carRow.carImages.compactMap { CarImageRow.carImage($0) })
                ])
                return cell
            }
        })
    }
}

private extension SearchResultView {
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
}
