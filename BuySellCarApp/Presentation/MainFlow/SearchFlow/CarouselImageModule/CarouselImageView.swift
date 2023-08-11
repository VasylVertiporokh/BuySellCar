//
//  CarouselImageView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 08/08/2023.
//

import UIKit
import Combine

enum CarouselImageViewAction {
    case closeDidTap
}

final class CarouselImageView: BaseView {
    // MARK: - Subviews
    private var collectionView: UICollectionView!
    private let closeButton = UIButton()
    private let imageCountLabel = UILabel()
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<CarouselImageViewAction, Never>()
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<AdsImageSection, AdsImageRow>?
    private var indexPath: IndexPath?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ModelConfigurableView
extension CarouselImageView: ModelConfigurableView {
    typealias Model = ViewModel
    
    func configure(model: Model) {
        setupSnapshot(sections: model.sections, selectedRow: model.selectedRow)
    }
    
    struct ViewModel {
        let sections: [SectionModel<AdsImageSection, AdsImageRow>]
        let selectedRow: AdsImageRow
    }
}

// MARK: - Private extenison
private extension CarouselImageView {
    func initialSetup() {
        setupLayout()
        setupDataSource()
        setupUI()
        bindActions()
    }

    func bindActions() {
        closeButton.tapPublisher
            .sink { [unowned self] in actionSubject.send(.closeDidTap) }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        backgroundColor = .black
        closeButton.setImage(Assets.closeBigIcon.image.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.imageView?.tintColor = .white
        imageCountLabel.font = Constant.countLableFont
        imageCountLabel.textColor = .white
        imageCountLabel.textAlignment = .center
    }
    
    func setupLayout() {
        // collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .black
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.equalTo(snp.leading)
            $0.trailing.equalTo(snp.trailing)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        // close button
        addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.size.equalTo(Constant.buttonSize)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constant.defaultConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.defaultConstraint)
        }
        
        // imageCountLabel
        addSubview(imageCountLabel)
        imageCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(Constant.defaultConstraint)
            $0.centerX.equalTo(snp.centerX)
        }
    }
    
    func setupSnapshot(sections: [SectionModel<AdsImageSection, AdsImageRow>], selectedRow: AdsImageRow) {
        var snapShot = NSDiffableDataSourceSnapshot<AdsImageSection, AdsImageRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot)
    
        guard let indexPath = dataSource?.indexPath(for: selectedRow) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Constant.delayForScroll)) {
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
    }
}

// MARK: - Configure collection view
private extension CarouselImageView {
    func setupDataSource() {
        collectionView.register(cellType: ImageZoomCell.self)
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .adsImageRow(let image):
                let cell: ImageZoomCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.set(image: image)
                return cell
            }
        })
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
            widthDimension: .fractionalWidth(Constant.itemSize),
            heightDimension: .fractionalHeight(Constant.itemSize)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constant.itemSize),
            heightDimension: .fractionalHeight(Constant.itemSize)
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
    
    func setNumberOfPages(pageNumber: Int) {
        guard let itemCount = dataSource?.snapshot().numberOfItems(inSection: .adsImageSection) else {
            return
        }
        imageCountLabel.text = "\(pageNumber.incrementByOne)/\(itemCount)"
    }
}

// MARK: - View constants
private enum Constant {
    static let itemSize: CGFloat = 1.0
    static let buttonSize: CGFloat = 40
    static let defaultConstraint: CGFloat = 16
    static let countLableFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 18)
    static let delayForScroll: Int = 10
}
