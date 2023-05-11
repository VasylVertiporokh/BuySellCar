//
//  FilterView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 03.04.2023.
//

import Foundation
import UIKit
import SnapKit
import Combine

enum FilterViewAction {
    case deleteSearchParam(SearchParam)
}

final class FilterView: BaseView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let buttonContainerView = UIView()
    private let filterButton = MainButton(type: .filter)
    private let collectionContainer = UIStackView()
    private var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<FilteredSection, FilteredRow>?
    
    // MARK: - Subjects
    private(set) lazy var filterViewActionAction = filterViewActionSubject.eraseToAnyPublisher()
    private let filterViewActionSubject = PassthroughSubject<FilterViewAction, Never>()
    
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
extension FilterView {
    func setupSnapshot(sections: [SectionModel<FilteredSection, FilteredRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<FilteredSection, FilteredRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot)
    }
}

// MARK: - Private extension
private extension FilterView {
    func initialSetup() {
        setupUI()
        configureCollectionView()
        setupDataSource()
        setupLayout()
    }
    
    func setupUI() {
        backgroundColor = .white
        filterButton.titleLabel?.font = Constants.filterButtonFont
    }
    
    func setupLayout() {
        addSubview(containerStackView)
        containerStackView.axis = .horizontal
        containerStackView.spacing = Constants.containerStackViewSpacing
        
        buttonContainerView.addSubview(filterButton)
        buttonContainerView.snp.makeConstraints { $0.width.equalTo(Constants.buttonContainerViewWidth) }
        
        filterButton.snp.makeConstraints {
            $0.top.equalTo(buttonContainerView.snp.top).inset(Constants.filterButtonConstraint)
            $0.bottom.equalTo(buttonContainerView.snp.bottom).inset(Constants.filterButtonConstraint)
            $0.leading.equalTo(buttonContainerView.snp.leading).offset(Constants.filterButtonConstraint)
            $0.trailing.equalTo(buttonContainerView.snp.trailing).inset(Constants.filterButtonConstraint)
        }
        containerStackView.addArrangedSubview(buttonContainerView)
        containerStackView.addArrangedSubview(collectionContainer)
        
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}

// MARK: - Configure collection view
private extension FilterView {
    func configureCollectionView() {
        collectionView = .init(
            frame: collectionContainer.bounds,
            collectionViewLayout: createLayout()
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.isScrollEnabled = false
        collectionContainer.addArrangedSubview(collectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self,
                  let dataSource = self.dataSource else { return nil }
            
            let sections = dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sections {
            case .filtered:
                return self.filteredParamsSectionLayout()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config

        return layout
    }

    func filteredParamsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(Constants.cellEstimatedWidth),
            heightDimension: .fractionalHeight(Constants.cellHeight)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(Constants.groupEstimatedWidth),
            heightDimension: .absolute(Constants.groupEstimatedHeight)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        return section
    }

    func setupDataSource() {
        collectionView.register(cellType: FilteredCell.self)
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .filteredParameter(let parameter):
                let cell: FilteredCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setFilteredParam(parameter)
                cell.deleteItem = { [weak self] in
                    guard let self = self else { return }
                    switch item {
                    case .filteredParameter(let searchPram):
                        self.filterViewActionSubject.send(.deleteSearchParam(searchPram))
                    }
                }
                return cell
            }
        })
    }
}

// MARK: - Constants
private enum Constants {
    static let filterButtonFont: UIFont = FontFamily.Montserrat.regular.font(size: 12)
    static let containerStackViewSpacing: CGFloat = 4
    static let buttonContainerViewWidth: CGFloat = 100
    static let filterButtonConstraint: CGFloat = 8
    static let cellHeight: CGFloat = 1.0
    static let cellEstimatedWidth: CGFloat = 120
    static let groupEstimatedHeight: CGFloat = 50
    static let groupEstimatedWidth: CGFloat = 120
}
