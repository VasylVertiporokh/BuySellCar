//
//  FirstRegistrationView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 17.05.2023.
//

import UIKit
import SnapKit
import Combine

enum FirstRegistrationViewAction {
    case firstRegistrationData(Date)
    case dismiss
}

final class FirstRegistrationView: BaseView {
    // MARK: - Subviews
    private let conteinerView = UIView()
    private let pickerView = UIDatePicker()
    
    // MARK: - Action publisher
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<FirstRegistrationViewAction, Never>()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal extenison
extension FirstRegistrationView {
    func launchViewAnimation() {
        UIView.animate(withDuration: Constant.animationDuration) {
            self.conteinerView.transform = Constant.normalScale
            self.backgroundColor = Constant.backgroundColor
        }
    }
}


// MARK: - Private extension
private extension FirstRegistrationView {
    func initialSetup() {
        setupLayout()
        setupUI()
        bindActions()
        addGesture()
    }
    
    func bindActions() {
        pickerView.datePublisher
            .map { FirstRegistrationViewAction.firstRegistrationData($0) }
            .sink { [unowned self] in actionSubject.send($0) }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        backgroundColor = .black.withAlphaComponent(.zero)
        conteinerView.dropShadow()
        conteinerView.backgroundColor = .white
        conteinerView.transform = Constant.maxScale
        pickerView.datePickerMode = .date
        pickerView.preferredDatePickerStyle = .wheels
    }
    
    func setupLayout() {
        addSubview(conteinerView)
        conteinerView.addSubview(pickerView)
        
        conteinerView.snp.makeConstraints {
            $0.leading.equalTo(snp.leading).offset(Constant.defaultConstraint)
            $0.trailing.equalTo(snp.trailing).inset(Constant.defaultConstraint)
            $0.height.equalTo(Constant.containerViewHeight)
            $0.centerY.equalTo(snp.centerY)
        }
        
        pickerView.snp.makeConstraints { $0.edges.equalTo(conteinerView) }
    }
    
    func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.closeDatePicker))
        addGestureRecognizer(gesture)
    }
    
    func closeViewAnimation() {
        UIView.animate(withDuration: Constant.animationDuration, animations: {
            self.conteinerView.transform = Constant.minScale
            self.backgroundColor = .clear
        }, completion: {_ in
            self.conteinerView.isHidden = true
            self.actionSubject.send(.dismiss)
        })
    }
}

// MARK: - Actions
private extension FirstRegistrationView {
    @objc
    func closeDatePicker() {
        closeViewAnimation()
    }
}

// MARK: - View constants
private enum Constant {
    static let animationDuration: Double = 0.33
    static let minScale = CGAffineTransform(scaleX: 0.1, y: 0.1)
    static let maxScale = CGAffineTransform(scaleX: .zero, y: .zero)
    static let containerViewHeight: CGFloat = 200
    static let backgroundColor: UIColor = .black.withAlphaComponent(0.7)
    static let normalScale = CGAffineTransform(scaleX: 1.0, y: 1.0)
    static let defaultConstraint: CGFloat = 16
}
