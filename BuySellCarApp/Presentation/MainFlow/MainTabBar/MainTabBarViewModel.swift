//
//  MainTabBarViewModel.swift
//  MVVMSkeleton
//
//

import Combine

final class MainTabBarViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<MainTabBarTransition, Never>()
}
