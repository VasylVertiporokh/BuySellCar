//
//  RangeView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 20.04.2023.
//

import UIKit
import Combine

enum RangeViewAction {
    case selectedRange(RangeView.Range)
    case inputError
}

// MARK: - Range side
private enum RangeSide {
    case none
    case left
    case right
}

final class RangeView: UIView {
    // MARK: - Nested entities
    struct Range: Hashable {
        var lowerBound: Double
        var upperBound: Double
    }
    
    // MARK: - Subviews
    private let selectedRangeView = UIView()
    private var leftThumbView: UIView = UIView()
    private var rightThumbView: UIView = UIView()
    
    // MARK: - NSLayoutConstraints
    private var leftLeadingConstraint: NSLayoutConstraint!
    private var rightTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<RangeViewAction, Never>()
    private let lastValidRange = CurrentValueSubject<Range, Never>(Constant.defaultRange)
    
    // MARK: - Private properties
    private var cancellables = Set<AnyCancellable>()
    private var leftInputError = false
    private var rightInputError = false
    private var sliderStep = Constant.defaultStep
    private var selectedSide = RangeSide.none
    private var valuesRange = Constant.defaultRange
    private var selectedRange = Constant.defaultRange
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
        
        lastValidRange
            .sink { [unowned self] range in
                if leftInputError == false && rightInputError == false {
                    actionSubject.send(.selectedRange(range))
                }
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        drawTrackBlue(rect, context: context)
    }
    
    override func didMoveToWindow() {
        if let _ = window {
            updateLeftThumb(animated: false)
            updateRightThumb(animated: false)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == Constant.expectedNumberOfTouches, let location = touches.first?.location(in: self) else {
            return
        }
        
        findClosestThumb(at: location, left: {
            selectedSide = .left
        }, right: {
            selectedSide = .right
        })
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == Constant.expectedNumberOfTouches, let location = touches.first?.location(in: self) else {
            return
        }
        var newValue = value(from: location.x, in: bounds)
        
        if sliderStep > .zero { newValue = round(newValue / sliderStep) * sliderStep }
        
        switch selectedSide {
        case .left:
            newValue = min(max(newValue, valuesRange.lowerBound), lastValidRange.value.upperBound - sliderStep)
            lastValidRange.value = Range(lowerBound: newValue, upperBound: lastValidRange.value.upperBound)
            selectedRange = Range(lowerBound: newValue, upperBound: lastValidRange.value.upperBound)
            updateLeftThumb(animated: true)
        case .right:
            newValue = max(min(newValue, valuesRange.upperBound), lastValidRange.value.lowerBound + sliderStep)
            
            lastValidRange.value = Range(lowerBound: lastValidRange.value.lowerBound, upperBound: newValue)
            selectedRange = Range(lowerBound: lastValidRange.value.lowerBound, upperBound: newValue)
            updateRightThumb(animated: true)
        default:
            return
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedSide = .none
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedSide = .none
    }
}

// MARK: - Internal extension
extension RangeView {
    func configure(valuesRange: Range, selectedRange: Range, step: Double = Constant.defaultStep) {
        self.valuesRange = valuesRange
        self.selectedRange = selectedRange
        lastValidRange.value = selectedRange
        sliderStep = step
        
        updateLeftThumb(animated: true)
        updateRightThumb(animated: true)
    }
    
    func dropFilter(selectedRange: Range) {
        self.selectedRange = selectedRange
        lastValidRange.value = selectedRange
        updateLeftThumb(animated: true)
        updateRightThumb(animated: true)
        rightInputError = false
        leftInputError = false
    }
    
    func updateMinRange(_ minRange: String) {
        guard let value = Double(minRange) else {
            lastValidRange.value.lowerBound = valuesRange.lowerBound
            updateLeftThumb(animated: true)
            return
        }
        
        selectedRange = Range(lowerBound: value, upperBound: selectedRange.upperBound)
        
        let validInput = value <= selectedRange.upperBound && value <= valuesRange.upperBound
        let isSelectedRangeValid = selectedRange.lowerBound >= valuesRange.lowerBound
        
        leftInputError = !validInput
        
        guard validInput && isSelectedRangeValid else {
            actionSubject.send(.inputError)
            return
        }
        
        lastValidRange.value = Range(lowerBound: value, upperBound: lastValidRange.value.upperBound)
        updateLeftThumb(animated: true)
    }
    
    func updateMaxRange(_ maxRange: String) {
        guard let value = Double(maxRange) else {
            lastValidRange.value.upperBound = valuesRange.upperBound
            updateRightThumb(animated: true)
            return
        }
        selectedRange = Range(lowerBound: selectedRange.lowerBound, upperBound: value)
        
        let validInput = value >= selectedRange.lowerBound
        let upperBound = min(value, valuesRange.upperBound)
        rightInputError = !validInput
        
        guard validInput else {
            actionSubject.send(.inputError)
            return
        }
        lastValidRange.value = Range(lowerBound: lastValidRange.value.lowerBound, upperBound: upperBound)
        updateRightThumb(animated: true)
    }
}

// MARK: - Private extension
private extension RangeView {
    func initialSetup() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        addSubview(selectedRangeView)
        addSubview(leftThumbView)
        addSubview(rightThumbView)
        
        leftThumbView.widthAnchor.constraint(equalTo: leftThumbView.heightAnchor).isActive = true
        leftThumbView.widthAnchor.constraint(equalToConstant: Constant.thumbSize).isActive = true
        leftThumbView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        leftLeadingConstraint = leftThumbView.centerXAnchor.constraint(equalTo: leadingAnchor)
        leftLeadingConstraint.isActive = true
        
        rightThumbView.widthAnchor.constraint(equalTo: rightThumbView.heightAnchor).isActive = true
        rightThumbView.widthAnchor.constraint(equalTo: leftThumbView.widthAnchor).isActive = true
        rightThumbView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightTrailingConstraint = rightThumbView.centerXAnchor.constraint(equalTo: trailingAnchor)
        rightTrailingConstraint.isActive = true
        
        selectedRangeView.backgroundColor = Constant.selectionColor
        selectedRangeView.translatesAutoresizingMaskIntoConstraints = false
        selectedRangeView.heightAnchor.constraint(equalToConstant: Constant.trackWidth).isActive = true
        selectedRangeView.leadingAnchor.constraint(equalTo: leftThumbView.centerXAnchor).isActive = true
        selectedRangeView.trailingAnchor.constraint(equalTo: rightThumbView.centerXAnchor).isActive = true
        selectedRangeView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setupUI() {
        backgroundColor = .white
        [leftThumbView, rightThumbView].forEach {
            $0.layer.cornerRadius = Constant.thumbSize / Constant.halfThumbKoef
            $0.backgroundColor = Constant.thumbColor
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.dropShadow(
                shadowColor: .lightGray,
                shadowOffset: .init(width: 1, height: 1),
                shadowOpacity: 0.9,
                shadowRadius: 10
            )
        }
    }
    
    func updateLeftThumb(animated: Bool) {
        guard bounds != .zero else { return }
        
        let newValue = selection(in: bounds).lowerBound
        let duration = animated ? animationDuration(for: abs(leftLeadingConstraint.constant - newValue)) : .zero
        
        leftLeadingConstraint.constant = newValue
        animateUpdates(duration: duration)
    }
    
    func updateRightThumb(animated: Bool) {
        guard bounds.width != .zero else { return }
        
        let newValue = selection(in: bounds).upperBound - bounds.width
        let duration = animated ? animationDuration(for: abs(rightTrailingConstraint.constant - newValue)) : .zero
        
        rightTrailingConstraint.constant = newValue
        animateUpdates(duration: duration)
    }
    func animationDuration(for distance: CGFloat) -> TimeInterval {
        return Constant.halfThumbKoef * TimeInterval(distance / bounds.width)
    }
    
    func animateUpdates(duration: TimeInterval) {
        UIView.animate(
            withDuration: duration,
            delay: .zero,
            options: [.beginFromCurrentState, .curveEaseInOut],
            animations: {
                self.layoutIfNeeded()
            }, completion: nil
        )
    }
    
    func findClosestThumb(at location: CGPoint, left: () -> Void, right: () -> Void) {
        let selectionPosition = selection(in: bounds)
        let activeDistance = Constant.thumbSize
        let leftDistance = distance(of: location, toPoint: CGPoint(x: selectionPosition.lowerBound, y: bounds.midY))
        let rightDistance = distance(of: location, toPoint: CGPoint(x: selectionPosition.upperBound, y: bounds.midY))
        
        if leftDistance < activeDistance && leftDistance < rightDistance {
            left()
        } else if rightDistance < activeDistance {
            right()
        } else if leftInputError {
            left()
        } else if rightInputError {
            right()
        }
    }
    
    func distance(of point: CGPoint, toPoint: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - toPoint.x, Constant.halfThumbKoef) + pow(point.y - toPoint.y, Constant.halfThumbKoef))
    }
    
    func selection(in rect: CGRect) -> ClosedRange<CGFloat> {
        let width = rect.width - Constant.thumbSize
        let range = valuesRange.upperBound - valuesRange.lowerBound
        let lower = CGFloat((lastValidRange.value.lowerBound - valuesRange.lowerBound) / range) * width + Constant.thumbSize / Constant.halfThumbKoef
        let upper = CGFloat((lastValidRange.value.upperBound - valuesRange.lowerBound) / range) * width + Constant.thumbSize / Constant.halfThumbKoef
        self.setNeedsDisplay()
        return lower...upper
    }
    
    func value(from position: CGFloat, in rect: CGRect) -> Double {
        let range = valuesRange.upperBound - valuesRange.lowerBound
        let relativePosition = (position - Constant.thumbSize / Constant.halfThumbKoef) / (rect.width - Constant.thumbSize)
        return Double(relativePosition) * range + valuesRange.lowerBound
    }
    
    func drawTrackBlue(_ rect: CGRect, context: CGContext) {
        let path = UIBezierPath()
        context.saveGState()
        Constant.drawTrackColor.setStroke()
        path.lineWidth = Constant.trackWidth
        path.lineCapStyle = .round
        path.move(to: CGPoint(x: Constant.trackWidth / Constant.halfThumbKoef, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width - Constant.trackWidth / Constant.halfThumbKoef, y: rect.midY))
        path.stroke()
        context.restoreGState()
    }
}

// MARK: - Constant
private struct Constant {
    static let defaultRange: RangeView.Range = .init(lowerBound: .zero, upperBound: .infinity)
    static let thumbColor: UIColor = .white
    static let selectionColor: UIColor = .systemBlue
    static let thumbSize: CGFloat = 24.0
    static let trackWidth: CGFloat = 4.0
    static let defaultStep = 1.0
    static let halfThumbKoef: CGFloat = 2
    static let expectedNumberOfTouches: Int = 1
    static let drawTrackColor: UIColor = .systemBlue.withAlphaComponent(0.3)
}
