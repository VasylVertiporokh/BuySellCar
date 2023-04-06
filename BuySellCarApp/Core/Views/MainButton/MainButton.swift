//
//  MainButton.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 24.02.2023.
//

import UIKit
import SnapKit

final class MainButton: UIButton {
    // MARK: - Private properties
    private let type: MainButtonType
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Overrided
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: Constants.animationDuration,
                           delay: .zero,
                           options: [.beginFromCurrentState, .allowUserInteraction],
                           animations: {
                self.alpha = self.isHighlighted ? Constants.customAlpha : Constants.standartAlpha
            }, completion: nil)
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? Constants.standartAlpha : Constants.customAlpha
        }
    }
    
    // MARK: - Init
    init(type: MainButtonType) {
        self.type = type
        super.init(frame: .zero)
        setupButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch type {
        case .filter:
            layer.cornerRadius = bounds.height / 2
        default:
            layer.cornerRadius = Constants.cornerRadius
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal extension
extension MainButton {
    func showLoading() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.centerY.equalTo(snp.centerY)
        }
        DispatchQueue.main.async { self.isEnabled = false }
        self.isEnabled = false
        activityIndicator.startAnimating()
//        setTitleColor(.clear, for: .disabled)
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        isEnabled = true
        setTitleColor(type.titleColor, for: .normal)
        titleLabel?.textColor = .red
    }
}

// MARK: - Private extension
private extension MainButton {
    func setupButton() {
        setButtonImage()
        setTitle(type.buttonTitle, for: .normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(type.titleColor, for: .disabled)
        backgroundColor = type.buttonColor
        tintColor = .white
        titleLabel?.font = type.titleFont
    }
    
    func setButtonImage() {
        switch type {
        case .startSearch:
            setImage(Assets.searchIcon.image.withRenderingMode(.alwaysTemplate), for: .normal)
            imageEdgeInsets = .init(top: .zero, left: .zero, bottom: .zero, right: 24)
        case .filter:
            setImage(Assets.filterIcon.image.withRenderingMode(.alwaysTemplate), for: .normal)
            imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 16)
            imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            imageView?.contentMode = .scaleAspectFit
        default:
            break
        }
    }
}

// MARK: - Constants
private enum Constants {
    static let animationDuration: Double = 0.25
    static let standartAlpha: Double = 1
    static let customAlpha: Double = 0.5
    static let cornerRadius: Double = 10
}
