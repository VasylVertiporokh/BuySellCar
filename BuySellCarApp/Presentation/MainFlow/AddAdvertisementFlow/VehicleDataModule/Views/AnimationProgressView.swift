//
//  AnimationProgressView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.05.2023.
//

import UIKit
import SnapKit

final class AnimationProgressView: UIView {
    // MARK: - Private properties
    private var mainColor: UIColor = Colors.buttonDarkGray.color {
        didSet { setNeedsDisplay() }
    }
    private var gradientColor: UIColor = .white {
        didSet { setNeedsDisplay() }
    }
    
    private var progress: CGFloat = .zero {
        didSet { setNeedsDisplay() }
    }
    
    // MARK: - Layers
    private let progressLayer = CALayer()
    private let gradientLayer = CAGradientLayer()
    private let backgroundMask = CAShapeLayer()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        createAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
        createAnimation()
    }
    
    // MARK: - LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .lightGray
    }
    
    // MARK: - Draw
    override func draw(_ rect: CGRect) {
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
        layer.mask = backgroundMask
        progressLayer.frame = progressRect
        progressLayer.backgroundColor = UIColor.black.cgColor
        
        gradientLayer.frame = rect
        gradientLayer.colors = [mainColor.cgColor, gradientColor.cgColor, mainColor.cgColor]
        gradientLayer.endPoint = CGPoint(x: progress, y: 0.5)
    }
}

// MARK: - Internal extension
extension AnimationProgressView {
    func setupProgress(progress: CGFloat) {
        self.progress = progress
    }
}

// MARK: - Private extension
private extension AnimationProgressView {
    func setupLayers() {
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = progressLayer
        gradientLayer.locations = [0.35, 0.5, 0.65]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    }
    
    func createAnimation() {
        let flowAnimation = CABasicAnimation(keyPath: "locations")
        flowAnimation.fromValue = [-0.3, -0.15, 0]
        flowAnimation.toValue = [1, 1.15, 1.3]
        
        flowAnimation.isRemovedOnCompletion = false
        flowAnimation.repeatCount = Float.infinity
        flowAnimation.duration = 1
        
        gradientLayer.add(flowAnimation, forKey: "flowAnimation")
    }
}
