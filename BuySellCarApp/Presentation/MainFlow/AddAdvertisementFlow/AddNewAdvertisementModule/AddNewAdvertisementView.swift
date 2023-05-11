//
//  AddNewAdvertisementView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 11.05.2023.
//

import UIKit
import SnapKit
import Combine

enum AddNewAdvertisementViewAction {

}

final class AddNewAdvertisementView: BaseView {
    // MARK: - Subviews
    private var collectionView: UICollectionView!
    private let createAddButton = UIButton(type: .system)
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<CreatedAdvertisementsSection, CreatedAdvertisementsRow>?

    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AddNewAdvertisementViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private extension
private extension AddNewAdvertisementView {
    func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
        configureCollectionView()
    }

    func bindActions() {
    }

    func setupUI() {
        backgroundColor = .white
    }

    func setupLayout() {
        
    }
}

// MARK: - Internal section
extension AddNewAdvertisementView {
    func setupSnapshot(sections: [SectionModel<CreatedAdvertisementsSection, CreatedAdvertisementsRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<CreatedAdvertisementsSection, CreatedAdvertisementsRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}

// MARK: - Configure collection view
private extension AddNewAdvertisementView {
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalTo(snp.edges) }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self,
                  let dataSource = self.dataSource else { return nil }

            let sections = dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sections {
            case .createdAdvertisements:    return self.createdAdvertisementsSectionLayout()
            case .emptyState:               return self.emptyStateSectionLayout()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.interSectionSpacing = Constant.defaultSpace
        
        layout.configuration = config
        return layout
    }
    
    func createdAdvertisementsSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(
//            top: Constant.sectionTopInset,
//            leading: Constant.defaultSpace,
//            bottom: Constant.defaultSpace,
//            trailing: Constant.defaultSpace
//        )
//        section.interGroupSpacing = Constant.defaultSpace
        
        return section
    }
    
    func emptyStateSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

// MARK: - View constants
private enum Constant {
    
}

// MARK: - AdvertisementSearchResultSection
enum CreatedAdvertisementsSection: Hashable {
    case createdAdvertisements
    case emptyState
}

// MARK: - AdvertisementResultRow
enum CreatedAdvertisementsRow: Hashable {
    case createdAdvertisementsRow
    case emptyStateRow
}
