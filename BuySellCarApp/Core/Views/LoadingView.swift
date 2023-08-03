//
//  LoadingView.swift
//  MVVMSkeleton
//
//

import UIKit

//final class LoadingView: UIView {
//    static let tagValue: Int = 1234123
//
//    var isLoading: Bool = false {
//        didSet { isLoading ? start() : stop() }
//    }
//
//    private let indicator = UIActivityIndicatorView(style: .large)
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initialSetup()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func initialSetup() {
//        tag = LoadingView.tagValue
//        backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        indicator.color = .white
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(indicator)
//        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//    }
//
//    func start() {
//        indicator.startAnimating()
//    }
//
//    func stop() {
//        indicator.stopAnimating()
//    }
//}
import Lottie
final class LoadingView: UIView {
    static let tagValue: Int = 1234123

    var isLoading: Bool = false {
        didSet { isLoading ? start() : stop() }
    }

    private let indicator = LottieAnimationView(name: "loader")

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        tag = LoadingView.tagValue
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        indicator.contentMode = .scaleAspectFit
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 100).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }

    func start() {
        indicator.loopMode = .loop
        indicator.animationSpeed = 0.5
        indicator.play()
    }

    func stop() {
        indicator.stop()
    }
}
