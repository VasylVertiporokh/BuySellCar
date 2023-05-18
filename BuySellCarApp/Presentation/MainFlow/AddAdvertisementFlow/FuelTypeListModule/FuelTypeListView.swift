//
//  FuelTypeListView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.05.2023.
//

import UIKit
import Combine

// MARK: - BrandSection
enum FuelTypeSection: Hashable {
    case carFuelTypeSection
}

// MARK: - VehicleDataRow
enum FuelTypeRow: Hashable {
    case carFuelTypeRow(FuelType)
}

// MARK: - FuelTypeListViewAction
enum FuelTypeListViewAction {
    case cellDidTap(FuelTypeRow)
}

final class FuelTypeListView: BaseView {
    // MARK: - Subviews
    private var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<FuelTypeSection, FuelTypeRow>?
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<FuelTypeListViewAction, Never>()
    
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
extension FuelTypeListView {
    func setupSnapshot(sections: [SectionModel<FuelTypeSection, FuelTypeRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<FuelTypeSection, FuelTypeRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}

// MARK: - Private extension
private extension FuelTypeListView {
    func initialSetup() {
        configureCollectionView()
        setupDataSource()
        setupLayout()
        setupUI()
        bindActions()
    }
    
    func bindActions() {
        collectionView.didSelectItemPublisher
            .compactMap { self.dataSource?.itemIdentifier(for: $0) }
            .map { FuelTypeListViewAction.cellDidTap($0) }
            .sink { [unowned self] in actionSubject.send($0) }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        backgroundColor = .white
    }
    
    func setupLayout() {}
}
// MARK: - Configure collection view
private extension FuelTypeListView {
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
            case .carFuelTypeSection:
                return self.createFuelTypeSectionLayout()
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
            case .carFuelTypeRow(let type):
                let cell: SearchPlainCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setFuelType(fuelType: type)
                return cell
            }
        })
    }
    
    func createFuelTypeSectionLayout() -> NSCollectionLayoutSection {
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
