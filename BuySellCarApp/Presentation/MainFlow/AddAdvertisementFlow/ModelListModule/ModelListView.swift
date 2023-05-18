//
//  ModelListView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 17.05.2023.
//

import UIKit
import Combine

// MARK: - BrandSection
enum CarModelSection: Hashable {
    case carModelSection
}

// MARK: - VehicleDataRow
enum CarModelRow: Hashable {
    case carModelRow(ModelCellConfigurationModel)
}

// MARK: - ModelListViewAction
enum ModelListViewAction {
    case cellDidTap(CarModelRow)
}

final class ModelListView: BaseView {
    // MARK: - Subviews
    private var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<CarModelSection, CarModelRow>?
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<ModelListViewAction, Never>()
    
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
extension ModelListView {
    func setupSnapshot(sections: [SectionModel<CarModelSection, CarModelRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<CarModelSection, CarModelRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}

// MARK: - Private extension
private extension ModelListView {
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
            .map { ModelListViewAction.cellDidTap($0) }
            .sink { [unowned self] in actionSubject.send($0) }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        backgroundColor = .white
    }
    
    func setupLayout() {}
}

// MARK: - Configure collection view
private extension ModelListView {
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
            case .carModelSection:
                return self.createCarModelSectionLayout()
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
            case .carModelRow(let model):
                let cell: SearchPlainCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setModel(from: model)
                return cell
            }
        })
    }
    
    func createCarModelSectionLayout() -> NSCollectionLayoutSection {
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
