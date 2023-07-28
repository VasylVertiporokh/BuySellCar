//
//  TechnicalSpecCell.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 24.04.2023.
//

import UIKit
import SnapKit
import Combine

final class TechnicalSpecCell: UICollectionViewCell {
    // MARK: - Subviews
    private let containerStackView = UIStackView()
    private let textFieldsStackView = UIStackView()
    private let toLabel = UILabel()
    private let minValueTextField = MainTextField(type: .plain)
    private let maxValueTextField = MainTextField(type: .plain)
    private var rangeSlider = RangeView()
    
    var rangeHandler: ((TechnicalSpecCellModel.SelectedRange) -> Void)?
    
    // MARK: - Private properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
        minValueTextField.controlEventPublisher(for: .editingDidEnd)
            .sink { [unowned self] in rangeSlider.updateMinRange(minValueTextField.text ?? Constant.emptyString) }
            .store(in: &cancellables)
        
        maxValueTextField.controlEventPublisher(for: .editingDidEnd)
            .sink { [unowned self] in rangeSlider.updateMaxRange(maxValueTextField.text ?? Constant.emptyString) }
            .store(in: &cancellables)
        
        minValueTextField.doneButtonActionPublisher
            .sink { [unowned self] in endEditing(true) }
            .store(in: &cancellables)
        
        maxValueTextField.doneButtonActionPublisher
            .sink { [unowned self] in endEditing(true) }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal extension
extension TechnicalSpecCell {
    func setDataModel(_ model: TechnicalSpecCellModel) {
        rangeSlider.configure(model: model)
        
        minValueTextField.text = model.minSelected.map { "\(Int($0))" }
        maxValueTextField.text = model.maxSelected.map { "\(Int($0))" }
        
        rangeSlider.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .rangeUpdatingInProgress(let range):
                    let isMinValuesEqual = range.lowerBound == model.inRange.lowerBound
                    let isMaxValuesEqual = range.upperBound == model.inRange.upperBound
                    
                    minValueTextField.text = isMinValuesEqual ? Constant.emptyString : "\(Int(range.lowerBound))"
                    maxValueTextField.text = isMaxValuesEqual ? Constant.emptyString : "\(Int(range.upperBound))"
                    
                case .rangeUpdated(let range):
                    let isMinValuesEqual = range.lowerBound == model.inRange.lowerBound
                    let isMaxValuesEqual = range.upperBound == model.inRange.upperBound
                    
                    rangeHandler?(
                        .init(minRangeValue: isMinValuesEqual ? nil : range.lowerBound,
                              maxRangeValue: isMaxValuesEqual ? nil : range.upperBound)
                    )
                    
                case .inputError:
                    rangeHandler?(.init(minRangeValue: nil, maxRangeValue: nil))
                    rangeSlider.dropFilter(selectedRange: model.inRange)
                    minValueTextField.text = Constant.emptyString
                    maxValueTextField.text = Constant.emptyString
                }
            }
            .store(in: &cancellables)
    }
}


// MARK: - Private extension
private extension TechnicalSpecCell {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        contentView.addSubview(containerStackView)
        containerStackView.axis = .vertical
        containerStackView.spacing = Constant.containerStackViewSpacing
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins.top = Constant.containerStackViewTopInset
        containerStackView.addArrangedSubview(textFieldsStackView)
        containerStackView.addArrangedSubview(rangeSlider)
        
        textFieldsStackView.axis = .horizontal
        textFieldsStackView.spacing = Constant.textFieldsStackViewSpacing
        textFieldsStackView.addArrangedSubview(minValueTextField)
        textFieldsStackView.addArrangedSubview(toLabel)
        textFieldsStackView.addArrangedSubview(maxValueTextField)
        textFieldsStackView.addSpacer()
        
        containerStackView.snp.makeConstraints { $0.edges.equalTo(contentView.snp.edges) }
        minValueTextField.snp.makeConstraints {
            $0.width.equalTo(Constant.textFieldWidth)
            $0.height.equalTo(Constant.textFieldHeight)
        }
        maxValueTextField.snp.makeConstraints {
            $0.width.equalTo(Constant.textFieldWidth)
            $0.height.equalTo(Constant.textFieldHeight)
        }
        rangeSlider.snp.makeConstraints { $0.height.equalTo(Constant.doubleSliderViewHeight) }
    }
    
    func setupUI() {
        toLabel.text = Constant.toLabelText
        [minValueTextField, maxValueTextField].forEach {
            $0.placeholder = Constant.textFieldPlaceholder
            $0.keyboardType = .numberPad
            $0.showToolbar = true
        }
    }
}

// MARK: - Constant
private enum Constant {
    static let containerStackViewSpacing: CGFloat = 32
    static let containerStackViewTopInset: CGFloat = 20
    static let textFieldsStackViewSpacing: CGFloat = 8
    static let textFieldHeight: CGFloat = 25
    static let textFieldWidth: CGFloat = 90
    static let doubleSliderViewHeight: CGFloat = 40
    static let toLabelText: String = "to"
    static let textFieldPlaceholder: String = "Any"
    static let trackWidth: CGFloat = 4
    static let emptyString: String = ""
    static let zeroValue: Double = 0
    static let inputDebounce: RunLoop.SchedulerTimeType.Stride = 2
}
