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
    private let searchStackView = UIStackView()
    private let buttonsStackView = UIStackView()
    private let cancelButton = UIButton(type: .system)
    private let doneButton = UIButton(type: .system)
    private let searchBarView = UISearchBar()
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<CarModelSection, CarModelRow>?
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<ModelListViewAction, Never>()
    
    // MARK: - Filter publisher
    private(set) lazy var filterPublisher = filterSubject.eraseToAnyPublisher()
    private let filterSubject = PassthroughSubject<FiterViewAction, Never>()
    
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
    
    func configureWithSearchView() {
        searchStackView.isHidden = false
    }
}

// MARK: - Private extension
private extension ModelListView {
    func initialSetup() {
        configureCollectionView()
        setupDataSource()
        configureStackViews()
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
        
        searchBarView.textDidChangePublisher
            .sink{ [unowned self] in filterSubject.send(.filterTextDidEntered($0)) }
            .store(in: &cancellables)
        
        cancelButton.tapPublisher
            .sink { [unowned self] in filterSubject.send(.cancelDidTapped) }
            .store(in: &cancellables)
        
        doneButton.tapPublisher
            .sink { [unowned self] in filterSubject.send(.doneDidTapped) }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        backgroundColor = .white
        searchStackView.isHidden = true
        searchBarView.backgroundImage = UIImage()
        searchStackView.backgroundColor = .white
        cancelButton.setTitle(Localization.cancel, for: .normal)
        cancelButton.setTitleColor(Colors.buttonDarkGray.color, for: .normal)
        cancelButton.titleLabel?.font = Constant.cancelButtonFont
        doneButton.setTitle(Localization.done, for: .normal)
        doneButton.setTitleColor(Colors.buttonDarkGray.color, for: .normal)
        doneButton.titleLabel?.font = Constant.doneButtonFont
    }
    
    func setupLayout() {
        addSubview(searchStackView)
        searchStackView.addArrangedSubview(buttonsStackView)
        searchStackView.addArrangedSubview(searchBarView)
        
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(doneButton)
        
        searchStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(snp.leading)
            $0.trailing.equalTo(snp.trailing)
        }
    }
    
    func configureStackViews() {
        searchStackView.axis = .vertical
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.isLayoutMarginsRelativeArrangement = true
        buttonsStackView.layoutMargins = Constant.buttonsStackViewMargins
        searchBarView.layoutMargins = Constant.searchBarViewMargins
    }
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
        section.contentInsets.top = searchStackView.isHidden ? .zero : searchStackView.bounds.height
        return section
    }
}

// MARK: - View constants
private enum Constant {
    static let layoutSize:NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1.0))
    static let itemSize:NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(47))
    static let buttonsStackViewMargins: UIEdgeInsets = .init(top: 8, left: 16, bottom: .zero, right: 16)
    static let searchBarViewMargins: UIEdgeInsets = .init(top: .zero, left: 16, bottom: .zero, right: 16)
    static let cancelButtonFont: UIFont = FontFamily.Montserrat.regular.font(size: 14)
    static let doneButtonFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 14)
}
