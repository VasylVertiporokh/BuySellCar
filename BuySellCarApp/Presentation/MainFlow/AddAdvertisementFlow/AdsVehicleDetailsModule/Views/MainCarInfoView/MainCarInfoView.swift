//
//  MainCarInfoView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 19.05.2023.
//

import UIKit
import SnapKit
import Combine

// MARK: - SelectedImageSection
enum SelectedImageSection: Hashable {
    case selectedImageSection
}

// MARK: - SelectedImageRow
enum SelectedImageRow: Hashable {
    case selectedImageRow(Data)
}

// MARK: - MainCarInfoViewAction
enum MainCarInfoViewAction {
    case price(Int)
    case power(Int)
    case millage(Int)
    case addPhotoDidTapped
    case changeRegistrationDidTapped
}

final class MainCarInfoView: BaseView {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let carDetailsStackView = UIStackView()
    private let collectionContainerStackView = UIStackView()
    private var carImageCollectionView: UICollectionView!
    private let emptyStateImageView = UIImageView()
    private let addPhotoButton = UIButton(type: .system)
    private let counterLabel = UILabel()
    private let shotDescriptionStackView = UIStackView()
    private let brandModelLabel = UILabel()
    private let shortDescriptionTextField = MainTextField(type: .editable)
    private let separatorView = UIView()
    private let pricePowerStackView = UIStackView()
    private let priceStackView = UIStackView()
    private let priceTitleLabel = UILabel()
    private let priceTextField = MainTextField(type: .editable)
    private let powerStackView = UIStackView()
    private let powerTextField = MainTextField(type: .editable)
    private let powerTitleLabel = UILabel()
    private let millageRegistrationStackView = UIStackView()
    private let millageStackView = UIStackView()
    private let millageTitleLabel = UILabel()
    private let millageTextField = MainTextField(type: .editable)
    private let registrationDateStackView = UIStackView()
    private let registrationTitleLabel = UILabel()
    private let registrationTextField = MainTextField(type: .editable)
    private let fakeFooterStackView = UIStackView()
    private let fakeFooterImageView = UIImageView()
    private let fakeFooterTitleLabel = UILabel()
        
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<SelectedImageSection, SelectedImageRow>?
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<MainCarInfoViewAction, Never>()
    
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
extension MainCarInfoView {
    func setMainDetailsFromModel(_ model: AddAdvertisementDomainModel) {
        guard let make = model.make,
              let carModel = model.model,
              let firstRegistration = model.firstRegistration?.dateString,
              let bodyColor = model.bodyColor?.rawValue,
              let fuelType = model.fuelType?.rawValue else {
            return
        }
        shortDescriptionTextField.text = "\(make) \(carModel) \(fuelType) \(bodyColor)"
        brandModelLabel.text = "\(make) \(carModel)"
        registrationTextField.text = firstRegistration
    }
    
    func setupSnapshot(sections: [SectionModel<SelectedImageSection, SelectedImageRow>]) {
        var snapShot = NSDiffableDataSourceSnapshot<SelectedImageSection, SelectedImageRow>()
        for section in sections {
            snapShot.appendSections([section.section])
            snapShot.appendItems(section.items, toSection: section.section)
        }
        dataSource?.apply(snapShot)
    }
    
    func setEmptyState(_ isEmptyState: Bool) {
        counterLabel.isHidden = isEmptyState
        carImageCollectionView.isHidden = isEmptyState
        emptyStateImageView.isHidden = !isEmptyState
    }
    
    func shakeTextFields() {
        [priceTextField, millageTextField, powerTextField].forEach { $0.shake() }
    }
}

// MARK: - Private extension
private extension MainCarInfoView {
    func initialSetup() {
        configureCollectionView()
        setupLayout()
        configureStackViews()
        setupLayout()
        configureUI()
        setupDataSource()
        bindAction()
        collectionContainerStackView.backgroundColor = .lightGray
    }
    
    func configureStackViews() {
        containerStackView.axis = .vertical
        containerStackView.spacing = Constant.minStackViewSpacing
        carDetailsStackView.axis = .vertical
        carDetailsStackView.spacing = Constant.detailsStackViewSpacing
        carDetailsStackView.isLayoutMarginsRelativeArrangement = true
        carDetailsStackView.layoutMargins = Constant.carDetailsStackViewMargins
        carDetailsStackView.axis = .vertical
        carDetailsStackView.spacing = Constant.detailsStackViewSpacing
        shotDescriptionStackView.axis = .vertical
        shotDescriptionStackView.spacing = Constant.containerStackViewSpacing
        pricePowerStackView.axis = .horizontal
        pricePowerStackView.distribution = .fillEqually
        pricePowerStackView.spacing = Constant.containerStackViewSpacing
        priceStackView.axis = .vertical
        priceStackView.spacing = Constant.containerStackViewSpacing
        powerStackView.axis = .vertical
        powerStackView.spacing = Constant.containerStackViewSpacing
        millageRegistrationStackView.axis = .horizontal
        millageRegistrationStackView.distribution = .fillEqually
        millageRegistrationStackView.spacing = Constant.containerStackViewSpacing
        millageStackView.axis = .vertical
        millageStackView.spacing = Constant.containerStackViewSpacing
        registrationDateStackView.axis = .vertical
        registrationDateStackView.spacing = Constant.containerStackViewSpacing
        fakeFooterStackView.axis = .horizontal
        fakeFooterStackView.spacing = Constant.minStackViewSpacing
    }
    
    func setupLayout() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(collectionContainerStackView)
        collectionContainerStackView.addArrangedSubview(carImageCollectionView)
        collectionContainerStackView.addArrangedSubview(emptyStateImageView)
        carDetailsStackView.addSubview(addPhotoButton)
        containerStackView.addArrangedSubview(carDetailsStackView)
        carDetailsStackView.addArrangedSubview(shotDescriptionStackView)
        shotDescriptionStackView.addArrangedSubview(brandModelLabel)
        shotDescriptionStackView.addArrangedSubview(shortDescriptionTextField)
        carDetailsStackView.addArrangedSubview(separatorView)
        carDetailsStackView.addArrangedSubview(pricePowerStackView)
        priceStackView.addArrangedSubview(priceTitleLabel)
        priceStackView.addArrangedSubview(priceTextField)
        powerStackView.addArrangedSubview(powerTitleLabel)
        powerStackView.addArrangedSubview(powerTextField)
        pricePowerStackView.addArrangedSubview(priceStackView)
        pricePowerStackView.addArrangedSubview(powerStackView)
        carDetailsStackView.addArrangedSubview(millageRegistrationStackView)
        millageRegistrationStackView.addArrangedSubview(millageStackView)
        millageRegistrationStackView.addArrangedSubview(registrationDateStackView)
        millageStackView.addArrangedSubview(millageTitleLabel)
        millageStackView.addArrangedSubview(millageTextField)
        registrationDateStackView.addArrangedSubview(registrationTitleLabel)
        registrationDateStackView.addArrangedSubview(registrationTextField)
        carDetailsStackView.addArrangedSubview(fakeFooterStackView)
        fakeFooterStackView.addArrangedSubview(fakeFooterImageView)
        fakeFooterStackView.addArrangedSubview(fakeFooterTitleLabel)
        
        containerStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        carImageCollectionView.snp.makeConstraints { $0.edges.equalTo(collectionContainerStackView) }
        
        addPhotoButton.snp.makeConstraints {
            $0.size.equalTo(Constant.addPhotoButtonSize)
            $0.trailing.equalTo(carDetailsStackView.snp.trailing).inset(Constant.addPhotoButtonConstraint)
            $0.centerY.equalTo(carDetailsStackView.snp.top)
        }
        
        shortDescriptionTextField.snp.makeConstraints { $0.height.equalTo(Constant.textFieldHeight) }
        separatorView.snp.makeConstraints { $0.height.equalTo(Constant.separatorViewHeight) }
        
        collectionContainerStackView.addSubview(counterLabel)
        collectionContainerStackView.snp.makeConstraints { $0.height.equalTo(Constant.collectionContainerViewHeight) }
        
        priceTextField.snp.makeConstraints { $0.height.equalTo(Constant.textFieldHeight) }
        powerTextField.snp.makeConstraints { $0.height.equalTo(Constant.textFieldHeight) }
        millageTextField.snp.makeConstraints { $0.height.equalTo(Constant.textFieldHeight) }
        registrationTextField.snp.makeConstraints { $0.height.equalTo(Constant.textFieldHeight) }
        
        fakeFooterImageView.snp.makeConstraints { $0.size.equalTo(Constant.fakeFooterImageViewSize) }
        
        counterLabel.snp.makeConstraints {
            $0.leading.equalTo(collectionContainerStackView.snp.leading).offset(Constant.counterLabelConstraint)
            $0.bottom.equalTo(collectionContainerStackView.snp.bottom).inset(Constant.counterLabelConstraint)
            $0.width.equalTo(Constant.counterLabelWidth)
            $0.height.equalTo(Constant.counterLabelHeight)
        }
    }
    
    func configureUI() {
        configureLabels()
        configureTextFields()
        configureGesture()
        
        emptyStateImageView.contentMode = .scaleAspectFill
        emptyStateImageView.image = Assets.carPlaceholder.image
        addBottomBorder(with: .lightGray, andWidth: Constant.bottomBorderWidth)
        carDetailsStackView.backgroundColor = .systemGroupedBackground
        fakeFooterImageView.image = Assets.vehicleDataIcon.image
        addPhotoButton.backgroundColor = Colors.buttonYellow.color
        addPhotoButton.setImage(Assets.camera.image, for: .normal)
        addPhotoButton.tintColor = Colors.buttonDarkGray.color
        addPhotoButton.layer.cornerRadius = Constant.addPhotoButtonRadius
        separatorView.backgroundColor = .lightGray
    }
    
    func configureLabels() {
        counterLabel.textAlignment = .center
        counterLabel.backgroundColor = Colors.buttonDarkGray.color
        counterLabel.layer.borderWidth = Constant.counterLabelBorderWidth
        counterLabel.layer.borderColor = UIColor.white.cgColor
        counterLabel.layer.cornerRadius = Constant.counterLabelRadius
        counterLabel.clipsToBounds = true
        counterLabel.textColor = .white
        counterLabel.font = Constant.counterLabelFont
        fakeFooterTitleLabel.text = "Vehicle details"
        powerTitleLabel.text = "Power"
        priceTitleLabel.text = "Final price"
        millageTitleLabel.text = "Millage"
        registrationTitleLabel.text = "First registration"
        
        [brandModelLabel, fakeFooterTitleLabel].forEach {
            $0.textColor = Colors.buttonDarkGray.color
            $0.font = Constant.defaultTitleFont
        }
        
        [priceTitleLabel, powerTitleLabel, millageTitleLabel, registrationTitleLabel].forEach {
            $0.textColor = Colors.buttonDarkGray.color
            $0.font = Constant.titleLabeleFont
        }
    }
    
    func configureTextFields() {
        registrationTextField.isEnabled = false
        shortDescriptionTextField.isEnabled = false
        [shortDescriptionTextField, priceTextField, powerTextField, millageTextField, registrationTextField].forEach {
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = Constant.textFieldBorderWidth
            $0.layer.cornerRadius = Constant.textFieldRadius
            $0.placeholder = "Please insert"
            $0.keyboardType = .numberPad
            $0.rightView = nil
        }
    }
    
    func configureGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(registrationTextFieldDidTapped))
        registrationDateStackView.addGestureRecognizer(gestureRecognizer)
    }
    
    func bindAction() {
        priceTextField.textPublisher
            .replaceNil(with: "")
            .map { Int($0) }
            .replaceNil(with: .zero)
            .sink { [unowned self] in actionSubject.send(.price($0))}
            .store(in: &cancellables)
        
        powerTextField.textPublisher
            .replaceNil(with: "")
            .map { Int($0) }
            .replaceNil(with: .zero)
            .sink { [unowned self] in actionSubject.send(.power($0))}
            .store(in: &cancellables)
        
        millageTextField.textPublisher
            .replaceNil(with: "")
            .map { Int($0) }
            .replaceNil(with: .zero)
            .sink { [unowned self] in actionSubject.send(.millage($0))}
            .store(in: &cancellables)
        
        addPhotoButton.tapPublisher
            .sink { [unowned self] _ in actionSubject.send(.addPhotoDidTapped) }
            .store(in: &cancellables)
    }
}

// MARK: - Actions
private extension MainCarInfoView {
    @objc
    func registrationTextFieldDidTapped() {
        actionSubject.send(.changeRegistrationDidTapped)
    }
}

// MARK: - Configure collection view
private extension MainCarInfoView {
    func configureCollectionView() {
        carImageCollectionView = .init(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
    }
    
    func setupDataSource() {
        carImageCollectionView.register(cellType: CarImageCell.self)
        dataSource = .init(collectionView: carImageCollectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .selectedImageRow(let data):
                let cell: CarImageCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setImageFromData(data)
                return cell
            }
        })
    }
    
    func setNumberOfPages(pageNumber: Int) {
        guard let itemCount = dataSource?.snapshot().numberOfItems(inSection: .selectedImageSection) else {
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
            case .selectedImageSection:
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

// MARK: - Constant
private enum Constant {
    static let carDetailsStackViewMargins: UIEdgeInsets = .init(top: 24, left: 16, bottom: 16, right: 16)
    static let containerStackViewSpacing: CGFloat = 8
    static let detailsStackViewSpacing: CGFloat = 16
    static let collectionViewLayoutSize: CGFloat = 1.0
    static let titleLabeleFont: UIFont = FontFamily.Montserrat.regular.font(size: 12)
    static let defaultTitleFont: UIFont = FontFamily.Montserrat.regular.font(size: 16)
    static let counterLabelFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 10)
    static let collectionContainerViewHeight: CGFloat = 250
    static let counterLabelBorderWidth: CGFloat = 0.5
    static let counterLabelRadius: CGFloat = 4
    static let counterLabelConstraint: CGFloat = 16
    static let addPhotoButtonSize: CGFloat = 60
    static let textFieldHeight: CGFloat = 36
    static let separatorViewHeight: CGFloat = 1
    static let counterLabelHeight: CGFloat = 20
    static let counterLabelWidth: CGFloat = 30
    static let textFieldBorderWidth: CGFloat = 1
    static let textFieldRadius: CGFloat = 8
    static let addPhotoButtonRadius: CGFloat = 30
    static let minStackViewSpacing: CGFloat = 4
    static let addPhotoButtonConstraint: CGFloat = 16
    static let fakeFooterImageViewSize: CGFloat = 18
    static let bottomBorderWidth: CGFloat = 0.5
}
