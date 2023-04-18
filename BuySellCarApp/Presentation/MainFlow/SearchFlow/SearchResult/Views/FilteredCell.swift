//
//  FilteredCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 03.04.2023.
//

import Foundation
import Combine
import UIKit
import SnapKit

enum FilteredCellActions {
    case deleteSearchParam(SearchParam?)
}

final class FilteredCell: UICollectionViewCell {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let filterParamLabel = UILabel()
    private let deleteParamButton = UIButton(type: .system)
    
    // MARK: - Private properties
    private var cancellables = Set<AnyCancellable>()
    private(set) lazy var cellActionPublisher = cellActionSubject.eraseToAnyPublisher()
    private let cellActionSubject = PassthroughSubject<FilteredCellActions, Never>()
    private var searchParams: SearchParam?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        searchParams = nil
    }
}

// MARK: - Internal extension
extension FilteredCell {
    func setFilteredParam(_ parameter: SearchParam) {
        searchParams = parameter
        filterParamLabel.text = parameter.key.keyDescription + " " + parameter.value.searchValueDescription
    }
}

// MARK: - Private extension
private extension FilteredCell {
    func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        
        containerStackView.axis = .horizontal
        containerStackView.spacing = Constants.defaultSpacing
        containerStackView.alignment = .center
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = Constants.containerStackViewMargins
        
        
        containerStackView.addArrangedSubview(filterParamLabel)
        containerStackView.addArrangedSubview(deleteParamButton)
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(Constants.defaultSpacing)
            $0.bottom.equalTo(contentView.snp.bottom).inset(Constants.defaultSpacing)
            $0.leading.equalTo(contentView.snp.leading).offset(Constants.defaultSpacing)
            $0.trailing.equalTo(contentView.snp.trailing).inset(Constants.defaultSpacing)
        }
        deleteParamButton.snp.makeConstraints { $0.height.width.equalTo(Constants.deleteParamButtonHeight) }
    }
    
    func setupUI() {
        containerStackView.layer.borderColor = Colors.buttonDarkGray.color.cgColor
        containerStackView.layer.borderWidth = Constants.containerStackViewBorderWidth
        containerStackView.layer.cornerRadius = Constants.containerStackViewCornerRadius
        filterParamLabel.textAlignment = .left
        filterParamLabel.font = Constants.filterParamLabelFont
        deleteParamButton.setImage(Assets.closeCircleIcon.image.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func bindActions() {
        deleteParamButton.tapPublisher
            .sink { [unowned self] in
                cellActionSubject.send(.deleteSearchParam(searchParams))
            }
            .store(in: &cancellables)
    }
}

// MARK: - Constant
private enum Constants {
    static let defaultSpacing: CGFloat = 8
    static let containerStackViewMargins: UIEdgeInsets = .init(top: .zero, left: 8, bottom: .zero, right: 8)
    static let containerStackViewBorderWidth: CGFloat = 0.5
    static let containerStackViewCornerRadius: CGFloat = 17
    static let filterParamLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 12)
    static let deleteParamButtonHeight: CGFloat = 20
}
