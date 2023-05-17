//
//  BrandListView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import UIKit
import Combine

enum BrandListViewAction {
    case cellDidTap(BrandRow)
}

final class BrandListView: BaseView {
    // MARK: - Subviews
    private var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<BrandSection, BrandRow>?

    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<BrandListViewAction, Never>()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        setupDataSource()
        setupLayout()
        setupUI()
        bindActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal extension
extension BrandListView {
    func setupSnapshot(sections: [SectionModel<BrandSection, BrandRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<BrandSection, BrandRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}

// MARK: - Private extension
private extension BrandListView {
     func initialSetup() {
        setupLayout()
         setupUI()
         bindActions()
     }
    
    func bindActions() {
        collectionView.didSelectItemPublisher
            .compactMap { self.dataSource?.itemIdentifier(for: $0) }
            .map { BrandListViewAction.cellDidTap($0) }
            .sink { [unowned self] in actionSubject.send($0) }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        backgroundColor = .white
    }
    
    func setupLayout() {
        
    }
}

// MARK: - Configure collection view
private extension BrandListView {
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalTo(snp.edges) }
        collectionView.backgroundColor = .systemGroupedBackground
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self,
                  let dataSource = self.dataSource else { return nil }
            
            let sections = dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sections {
            case .brandSection:
                return self.createdAdvertisementsSectionLayout()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func setupDataSource() {
        collectionView.register(cellType: SearchPlainCell.self)
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .carBrandRow(let brand):
                let cell: SearchPlainCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setBrand(from: brand)
                return cell
            }
        })
    }
    
    func createdAdvertisementsSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: Constant.itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: Constant.layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

// MARK: - View constants
private enum Constant {
    static let layoutSize:NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1.0))
    static let itemSize:NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(47))
}

// MARK: - BrandSection
enum BrandSection: Hashable {
    case brandSection
}

// MARK: - VehicleDataRow
enum BrandRow: Hashable {
    case carBrandRow(BrandCellConfigurationModel)
}

struct BrandCellConfigurationModel: Hashable {
    let brandName: String
    let id: String
    
    init(brandDomainModel: BrandDomainModel) {
        self.brandName = brandDomainModel.name
        self.id = brandDomainModel.id
    }
}
