//
//  AdsImageView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 01/08/2023.
//

import UIKit
import SnapKit
import Combine

// MARK: - AdsImageSection
enum AdsImageSection: Hashable {
    case adsImageSection
}

// MARK: - AdsImageRow
enum AdsImageRow: Hashable {
    case adsImageRow(String?)
}

final class AdsImagesView: BaseView {
    // MARK: - Subviews
    private let containerView = UIView()
    private var collectionView: UICollectionView!
    private let counterLabel = UILabel()
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<AdsImageSection, AdsImageRow>?
    
    // MARK: - Selected image publisher
    private(set) lazy var rowSelectedPublisher = rowSelectedSubject.eraseToAnyPublisher()
    private let rowSelectedSubject = PassthroughSubject<AdsImageRow, Never>()
    
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
extension AdsImagesView {
    func setupSnapshot(sections: [SectionModel<AdsImageSection, AdsImageRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<AdsImageSection, AdsImageRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot)
    }
}

// MARK: - Private extension
private extension AdsImagesView {
    func initialSetup() {
        configureCollectionView()
        setupDataSource()
        setupLayout()
        setupUI()
        bindActions()
    }
    
    func setupLayout() {
        addSubview(containerView)
        
        containerView.addSubview(collectionView)
        containerView.addSubview(counterLabel)
        
        containerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        collectionView.snp.makeConstraints { $0.edges.equalTo(containerView) }
        
        counterLabel.snp.makeConstraints {
            $0.leading.equalTo(containerView.snp.leading).offset(Constant.counterLabelConstraint)
            $0.bottom.equalTo(containerView.snp.bottom).inset(Constant.counterLabelConstraint)
            $0.width.equalTo(Constant.counterLabelWidth)
            $0.height.equalTo(Constant.counterLabelHeight)
        }
    }
    
    func setupUI() {
        counterLabel.textAlignment = .center
        counterLabel.backgroundColor = Colors.buttonDarkGray.color
        counterLabel.layer.borderWidth = Constant.counterLabelBorderWidth
        counterLabel.layer.borderColor = UIColor.white.cgColor
        counterLabel.layer.cornerRadius = Constant.counterLabelRadius
        counterLabel.clipsToBounds = true
        counterLabel.textColor = .white
        counterLabel.font = Constant.counterLabelFont
    }
    
    func bindActions() {
        collectionView.didSelectItemPublisher
            .compactMap { self.dataSource?.itemIdentifier(for: $0) }
            .sink { [unowned self] in rowSelectedSubject.send($0) }
            .store(in: &cancellables)
    }
}

// MARK: - Configure collection view
private extension AdsImagesView {
    func configureCollectionView() {
        collectionView = .init(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
    }
    
    func setupDataSource() {
        collectionView.register(cellType: CarImageCell.self)
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .adsImageRow(let stringUrl):
                let cell: CarImageCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setImageURL(stringUrl)
                return cell
            }
        })
    }
    
    func setNumberOfPages(pageNumber: Int) {
        guard let itemCount = dataSource?.snapshot().numberOfItems(inSection: .adsImageSection) else {
            counterLabel.isHidden = true
            return
        }
        counterLabel.isHidden = itemCount.isEquallyOne
        counterLabel.text = "\(pageNumber.incrementByOne)/\(itemCount)"
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self,
                  let dataSource = self.dataSource else { return nil }
            
            let sections = dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sections {
            case .adsImageSection:
                return self.carImageSectionLayout()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func carImageSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.collectionViewLayoutSize),
            heightDimension: .fractionalHeight(Constant.collectionViewLayoutSize)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.collectionViewLayoutSize),
            heightDimension: .fractionalHeight(Constant.collectionViewLayoutSize)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        section.visibleItemsInvalidationHandler = { [weak self] (items, offset, _) -> Void in
            guard let self = self else { return }
            let page = offset.x / self.bounds.width
            self.setNumberOfPages(pageNumber: Int(round(page)))
        }
        return section
    }
}

// MARK: - Constanst
private enum Constant {
    static let collectionViewLayoutSize: CGFloat = 1.0
    static let counterLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 10)
    static let counterLabelBorderWidth: CGFloat = 0.5
    static let counterLabelRadius: CGFloat = 4
    static let counterLabelConstraint: CGFloat = 16
    static let counterLabelHeight: CGFloat = 20
    static let counterLabelWidth: CGFloat = 30
}
