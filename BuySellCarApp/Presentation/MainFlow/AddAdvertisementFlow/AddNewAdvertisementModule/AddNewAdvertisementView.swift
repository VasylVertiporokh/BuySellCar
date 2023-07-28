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
    case createAd
    case deleteAd(CreatedAdvertisementsRow)
}

final class AddNewAdvertisementView: BaseView {
    // MARK: - Subviews
    private var collectionView: UICollectionView!
    private let emptyStateView = EmptyStateView()
    private let createAddButton = UIButton(type: .system)
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<CreatedAdvertisementsSection, CreatedAdvertisementsRow>?

    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AddNewAdvertisementViewAction, Never>()

    // MARK: - Init
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
        configureCollectionView()
        setupDataSource()
        setupLayout()
        setupUI()
        bindActions()
    }

    func bindActions() {
        createAddButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.createAd) }
            .store(in: &cancellables)
    }

    func setupUI() {
        backgroundColor = .systemGroupedBackground
        createAddButton.backgroundColor = Colors.buttonYellow.color
        createAddButton.layer.cornerRadius = Constant.createAdButtonRadius
        createAddButton.tintColor = Colors.buttonDarkGray.color
        createAddButton.setTitle(Localization.createAdButtonTitle, for: .normal)
        createAddButton.titleLabel?.font = Constant.showResultsButtonFont
        emptyStateView.isHidden = true
        collectionView.isHidden = true
    }

    func setupLayout() {
        addSubview(emptyStateView)
        addSubview(createAddButton)
        
        emptyStateView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constant.emptyStateViewTopConstraint)
            $0.leading.equalTo(snp.leading).offset(Constant.defaultConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.defaultConstraint)
        }

        createAddButton.snp.makeConstraints {
            $0.height.equalTo(Constant.createAdButtonHeight)
            $0.leading.equalTo(snp.leading).offset(Constant.defaultConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.defaultConstraint)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(Constant.createAdButtonBottomConstraint)
        }
    }
}

// MARK: - Internal extension
extension AddNewAdvertisementView {
    func setupSnapshot(sections: [SectionModel<CreatedAdvertisementsSection, CreatedAdvertisementsRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<CreatedAdvertisementsSection, CreatedAdvertisementsRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
    
    func configureIfEmptyState(_ isEmpty: Bool) {
        emptyStateView.isHidden = isEmpty
        collectionView.isHidden = !isEmpty
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
            case .createdAdvertisements:
                return self.createdAdvertisementsSectionLayout()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func setupDataSource() {
        collectionView.register(cellType: UserAdsCell.self)
        
        dataSource = .init(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, item in
            switch item {
            case .createdAdvertisementsRow(let model):
                let cell: UserAdsCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(with: model)
                cell.deleteAds = { [unowned self] in actionSubject.send(.deleteAd(item)) }
                return cell
            }
        })
    }
    
    func createdAdvertisementsSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: Constant.itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: Constant.layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constant.sectionInterGroupSpacing
        section.contentInsets = Constant.sectionInsets
        return section
    }
}

// MARK: - View constants
private enum Constant {
    static let layoutSize:NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1.0))
    static let itemSize:NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
    static let sectionInsets: NSDirectionalEdgeInsets = .init(top: 16, leading: 16, bottom: 65, trailing: 16)
    static let emptyStateViewTopConstraint: CGFloat = 64
    static let sectionInterGroupSpacing: CGFloat = 16
    static let createAdButtonRadius: CGFloat = 8
    static let createAdButtonHeight: CGFloat = 47
    static let createAdButtonBottomConstraint: CGFloat = 10
    static let defaultConstraint: CGFloat = 16
    static let showResultsButtonFont: UIFont = FontFamily.Montserrat.medium.font(size: 14)
}

// MARK: - AdvertisementSearchResultSection
enum CreatedAdvertisementsSection: Hashable {
    case createdAdvertisements
}

// MARK: - AdvertisementResultRow
enum CreatedAdvertisementsRow: Hashable {
    case createdAdvertisementsRow(AdvertisementCellModel)
}
