//
//  SettingsView.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 14.12.2021.
//

import UIKit
import Combine

enum SettingsViewAction {
    case logoutTapped
    case rowSelected(SettingsRow)
}

final class SettingsView: BaseView {
    // MARK: - Subviews
    private var collectionListView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SettingsSection, SettingsRow>?
    
    // MARK: - Subjects
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SettingsViewAction, Never>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup() {
        setupLayout()
        setupUI()
        setupDataSource()
        bindActions()
    }
    
    private func bindActions() {
        collectionListView.didSelectItemPublisher
            .compactMap { self.dataSource?.itemIdentifier(for: $0) }
            .map { SettingsViewAction.rowSelected($0) }
            .sink { [unowned self]  in actionSubject.send($0) }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        backgroundColor = .white
    }
    
    private func setupLayout() {
        configureCollectionView()
        addSubview(collectionListView)
    }
}

// MARK: - Internal extension
extension SettingsView {
    func setupSnapshot(sections: [SectionModel<SettingsSection, SettingsRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<SettingsSection, SettingsRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot)
    }
}

// MARK: - Private extension
private extension SettingsView {
    func configureCollectionView() {
        let configuration = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            let listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            let sectionConfiguration = NSCollectionLayoutSection.list(
                using: listConfiguration,
                layoutEnvironment: layoutEnvironment)
            return sectionConfiguration
        }
        
        collectionListView = UICollectionView(frame: bounds, collectionViewLayout: configuration)
        collectionListView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionListView.collectionViewLayout = configuration
    }
    
    
    func setupDataSource() {
        collectionListView.register(UserInfoListCell.self, forCellWithReuseIdentifier: "userProfileCell")
        collectionListView.register(SettingsListCell.self, forCellWithReuseIdentifier: "settingsCell")
        
        dataSource = .init(collectionView: collectionListView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .userProfile(let model):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userProfileCell", for: indexPath) as! UserInfoListCell
                cell.cellItem = model
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingsCell", for: indexPath) as! SettingsListCell
                cell.title = item.title
                return cell
            }
        })
    }
}

// MARK: - View constants
private enum Constant {
    static let topCollectionViewInset: CGFloat = 16
    static let bottomCollectionViewInset: CGFloat = 8
}

import SwiftUI
struct SettingsViewPreview: PreviewProvider {
    static var previews: some View {
        ViewRepresentable(SettingsView())
    }
}
