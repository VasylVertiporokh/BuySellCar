//
//  AddAdvertisementImageView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.05.2023.
//

import UIKit
import Combine
import SnapKit

// MARK: - AdvertisementSearchResultSection
enum AddAdvertisementImageSection: Hashable {
    case addAdvertisementImage
}

// MARK: - AdvertisementResultRow
enum AddAdvertisementImageRow: Hashable {
    case carImageRow(AdsPhotoModel)
}

// MARK: - AddAdvertisementImageViewAction
enum AddAdvertisementImageViewAction {
    case adOrDeleteItem(AddAdvertisementImageRow)
}

final class AddAdvertisementImageView: BaseView {
    // MARK: - Subviews
    private let infoTitleLabel = UILabel()
    private var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<AddAdvertisementImageSection, AddAdvertisementImageRow>?
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<AddAdvertisementImageViewAction, Never>()
    
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
extension AddAdvertisementImageView {
    func setupSnapshot(sections: [SectionModel<AddAdvertisementImageSection, AddAdvertisementImageRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<AddAdvertisementImageSection, AddAdvertisementImageRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}

// MARK: - Configure collection view
private extension AddAdvertisementImageView {
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalTo(snp.edges) }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self,
                  let dataSource = self.dataSource else {
                return nil
            }
            
            let sections = dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sections {
            case .addAdvertisementImage:
                return self.createdSelectedImagesSectionLayout()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func setupDataSource() {
        collectionView.register(cellType: AddAdvertisementImageCell.self)
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .carImageRow(let model):
                let cell: AddAdvertisementImageCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(with: model)
                return cell
            }
        })
    }
    
    func createdSelectedImagesSectionLayout() -> NSCollectionLayoutSection {
        let itemSize: CGFloat = (bounds.width / Constant.numberItemsInLine) - Constant.itemSizeKoefWithInset
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(itemSize), heightDimension: .absolute(itemSize)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: Constant.layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = Constant.sectionInset
        return section
    }
}


// MARK: - Private extension
private extension AddAdvertisementImageView {
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
            .map { AddAdvertisementImageViewAction.adOrDeleteItem($0) }
            .sink { [unowned self] in actionSubject.send($0) }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        backgroundColor = .systemGroupedBackground
        collectionView.isScrollEnabled = false
        infoTitleLabel.backgroundColor = .white
        infoTitleLabel.numberOfLines = .zero
        infoTitleLabel.textAlignment = .center
        infoTitleLabel.font = Constant.infoTitleLabelFont
        infoTitleLabel.textColor = Colors.buttonDarkGray.color
        infoTitleLabel.text = "Take the pictures in landscape format and keep in mind to show the vehicle from all sides and in detail."
        
    }
    
    func setupLayout() {
        addSubview(infoTitleLabel)
        
        infoTitleLabel.snp.makeConstraints {
            $0.height.equalTo(Constant.sectionTopInset)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(snp.leading).offset(Constant.defaultConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.defaultConstraint)
        }
    }
}

// MARK: - View constants
private enum Constant {
    static let layoutSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1.0))
    static let sectionInset: NSDirectionalEdgeInsets = .init(top: 55, leading: 12, bottom: 0, trailing: 12)
    static let itemSizeKoefWithInset: CGFloat = 8
    static let sectionTopInset: CGFloat = 55
    static let numberItemsInLine: CGFloat = 3
    static let defaultConstraint: CGFloat = 16
    static let infoTitleLabelFont: UIFont = FontFamily.Montserrat.medium.font(size: 13)
}
