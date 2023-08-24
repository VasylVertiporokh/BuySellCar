//
//  LottieView.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 24/08/2023.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    // MARK: - Internal properties
    var name: String
    var loopMode: LottieLoopMode = .loop
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let animationView = LottieAnimationView(name: name, bundle: Bundle.main)
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
