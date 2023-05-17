//
//  VehicleDataView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import UIKit
import SnapKit
import Combine

enum VehicleDataViewAction {
    case cellDidTap(VehicleDataRow)
}

final class VehicleDataView: BaseView {
    // MARK: - Subviews
    private var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<VehicleDataSection, VehicleDataRow>?
    private let progressView = CreatingProgressView()
    private let continueButton = UIButton(type: .system)
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<VehicleDataViewAction, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal extension
extension VehicleDataView {
    func setupSnapshot(sections: [SectionModel<VehicleDataSection, VehicleDataRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<VehicleDataSection, VehicleDataRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}

// MARK: - Private extension
private extension VehicleDataView {
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
            .map { VehicleDataViewAction.cellDidTap($0) }
            .sink { [unowned self] in actionSubject.send($0) }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        backgroundColor = .systemGroupedBackground
        progressView.configureForStep(.createAd)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = Colors.buttonYellow.color
        continueButton.tintColor = Colors.buttonDarkGray.color
        continueButton.layer.cornerRadius = Constant.continueButtonRadius
        continueButton.titleLabel?.font = Constant.continueButtonFont
    }
    
    
    func setupLayout() {
        addSubview(progressView)
        addSubview(continueButton)
        progressView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(snp.leading)
            $0.trailing.equalTo(snp.trailing)
        }
        
        
        continueButton.snp.makeConstraints {
            $0.height.equalTo(Constant.continueButtonHeight)
            $0.leading.equalTo(snp.leading).offset(Constant.defaultConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.defaultConstraint)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(Constant.continueButtonBottomConstraint)
        }
    }
}

// MARK: - Configure collection view
private extension VehicleDataView {
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
            case .vehicleDataSection:
                return self.createdAdvertisementsSectionLayout()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }
    
    func setupDataSource() {
        collectionView.register(cellType: VehicleDataCell.self)
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .carBrandRow(let brand):
                let cell: VehicleDataCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(from: brand)
                return cell
            case .firstRegistrationRow(let firstRegistration):
                let cell: VehicleDataCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(from: firstRegistration)
                return cell
            case .bodyColorRow(let bodyColor):
                let cell: VehicleDataCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(from: bodyColor)
                return cell
            case .modelRow(let model):
                let cell: VehicleDataCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(from: model)
                return cell
            case .fuelTypeRow(let fuelType):
                let cell: VehicleDataCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configureCell(from: fuelType)
                return cell
            }
        })
    }
    
    func createdAdvertisementsSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: Constant.itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: Constant.layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.top = Constant.sectionTopInset
        return section
    }
}

// MARK: - View constants
private enum Constant {
    static let layoutSize:NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(1.0))
    static let itemSize:NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(47))
    static let continueButtonRadius: CGFloat = 8
    static let continueButtonHeight: CGFloat = 47
    static let sectionTopInset: CGFloat = 63
    static let defaultConstraint: CGFloat = 16
    static let continueButtonBottomConstraint: CGFloat = 8
    static let continueButtonFont: UIFont = FontFamily.Montserrat.medium.font(size: 14)
}


// MARK: - VehicleDataSection
enum VehicleDataSection: Hashable {
    case vehicleDataSection
}

// MARK: - VehicleDataRow
enum VehicleDataRow: Hashable {
    case carBrandRow(VehicleDataCellModel)
    case firstRegistrationRow(VehicleDataCellModel)
    case bodyColorRow(VehicleDataCellModel)
    case modelRow(VehicleDataCellModel)
    case fuelTypeRow(VehicleDataCellModel)
}
