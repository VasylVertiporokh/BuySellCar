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
    case showFilters
    case deleteBrandTapped(SelectedBrandModel)
    case deleteModelTapped(ModelsDomainModel)
    case deleteBodyTapped(BodyTypeModel)
    case deleteFuelTypeTapped(FuelTypeModel)
    case deleteRegistrationTapped(SearchParam)
    case deleteMillageTapped(SearchParam)
    case deletePowerTapped(SearchParam)
    case deleteTransmissionTapped(TransmissionTypeModel)
}

// Sections
enum SelectedFilterSection: Hashable {
    case selectedBrand
    case selectedModel
    case bodyType
    case fuelType
    case firstRegistration
    case millage
    case power
    case transmissionType
}

// Rows
enum SelectedFilterRow: Hashable {
    case selectedBrandRow(SelectedBrandModel)
    case selectedModelRow(ModelsDomainModel)
    case bodyTypeRow(BodyTypeModel)
    case fuelTypeRow(FuelTypeModel)
    case firstRegistrationRow(SearchParam)
    case millageRow(SearchParam)
    case powerRow(SearchParam)
    case transmissionTypeRow(TransmissionTypeModel)
}


final class FilterView: BaseView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let buttonContainerView = UIView()
    private let filterButton = MainButton(type: .filter)
    private let collectionContainer = UIStackView()
    private var collectionView: UICollectionView!
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<SelectedFilterSection, SelectedFilterRow>?
    
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
    func setupSnapshot(sections: [SectionModel<SelectedFilterSection, SelectedFilterRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<SelectedFilterSection, SelectedFilterRow>()
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
        setupBindings()
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
    
    func setupBindings() {
        filterButton.tapPublisher
            .sink { [unowned self] in filterViewActionSubject.send(.showFilters) }
            .store(in: &cancellables)
    }
}

// MARK: - Configure collection view
private extension FilterView {
    func configureCollectionView() {
        collectionView = .init(
            frame: collectionContainer.bounds,
            collectionViewLayout: createLayout()
        )
        collectionContainer.addArrangedSubview(collectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            guard let self = self  else { return nil }
                return self.filteredParamsSectionLayout()
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
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
            heightDimension: .fractionalHeight(Constants.cellHeight)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func setupDataSource() {
        collectionView.register(cellType: FilteredCell.self)
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            let cell: FilteredCell = collectionView.dequeueReusableCell(for: indexPath)
        
            switch item {
            case .selectedBrandRow(let selectedBrandModel):
                cell.setFilteredParam(selectedBrandModel.searchParam)
                cell.deleteItem = { [unowned self] in
                    filterViewActionSubject.send(.deleteBrandTapped(selectedBrandModel))
                }
                return cell
                
            case .selectedModelRow(let selectedModel):
                cell.setFilteredParam(selectedModel.searchParam)
                cell.deleteItem = { [unowned self] in
                    filterViewActionSubject.send(.deleteModelTapped(selectedModel))
                }
                return cell
                
            case .bodyTypeRow(let selectedBodyTypeModel):
                cell.setFilteredParam(selectedBodyTypeModel.searchParam)
                cell.deleteItem = { [unowned self] in
                    filterViewActionSubject.send(.deleteBodyTapped(selectedBodyTypeModel))
                }
                return cell
            
            case .fuelTypeRow(let selectedFuelTypeModel):
                cell.setFilteredParam(selectedFuelTypeModel.searchParam)
                cell.deleteItem = { [unowned self] in
                    filterViewActionSubject.send(.deleteFuelTypeTapped(selectedFuelTypeModel))
                }
                return cell
                
            case .transmissionTypeRow(let selectedTransmissionTypeModel):
                cell.setFilteredParam(selectedTransmissionTypeModel.searchParam)
                cell.deleteItem = { [unowned self] in
                    filterViewActionSubject.send(.deleteTransmissionTapped(selectedTransmissionTypeModel))
                }
                return cell
            
            case .firstRegistrationRow(let firstRegistrationSearchParams):
                cell.setFilteredParam(firstRegistrationSearchParams)
                cell.deleteItem = { [unowned self] in
                    filterViewActionSubject.send(.deleteRegistrationTapped(firstRegistrationSearchParams))
                }
                return cell
                
            case .millageRow(let millageSearchParams):
                cell.setFilteredParam(millageSearchParams)
                cell.deleteItem = { [unowned self] in
                    filterViewActionSubject.send(.deleteMillageTapped(millageSearchParams))
                }
                return cell
                
            case .powerRow(let powerSearchParams):
                cell.setFilteredParam(powerSearchParams)
                cell.deleteItem = { [unowned self] in
                    filterViewActionSubject.send(.deletePowerTapped(powerSearchParams))
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
    static let groupEstimatedWidth: CGFloat = 300
}
