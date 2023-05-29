//
//  FakeSplashView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.04.2023.
//

import UIKit
import Lottie
import Combine
import SnapKit

enum FakeSplashViewAction {

}

final class FakeSplashView: BaseView {
    // MARK: - Subviews
    private let lottieView = LottieAnimationView(name: "splashAnimation")
    private let appNameLabel = UILabel()
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<FakeSplashViewAction, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private extension
private extension FakeSplashView {
    func initialSetup() {
        setupLayout()
        setupUI()
        start()
        backgroundColor = .white
    }
    
    func setupUI() {
        backgroundColor = .white
        appNameLabel.textAlignment = .center
        appNameLabel.text = "BuySellCar"
        appNameLabel.font = Constant.appNameLabel
    }
    
    func setupLayout() {
        addSubview(lottieView)
        addSubview(appNameLabel)
        
        lottieView.snp.makeConstraints {
            $0.size.equalTo(Constant.lottieViewSize)
            $0.centerX.equalTo(snp.centerX)
            $0.centerY.equalTo(snp.centerY)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.top.equalTo(lottieView.snp.bottom)
            $0.leading.equalTo(snp.leading)
            $0.trailing.equalTo(snp.trailing)
        }
    }
    
    func start() {
        lottieView.loopMode = .loop
        lottieView.animationSpeed = Constant.animationSpeed
        lottieView.play()
    }
}

// MARK: - View constants
private enum Constant {
    static let lottieViewSize: CGFloat = 250
    static let animationSpeed: Double = 1.0
    static let appNameLabel: UIFont = FontFamily.Montserrat.semiBold.font(size: 32)
}
