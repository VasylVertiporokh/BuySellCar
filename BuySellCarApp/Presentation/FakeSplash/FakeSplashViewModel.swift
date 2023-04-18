//
//  FakeSplashViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 18.04.2023.
//

import Foundation
import Combine

final class FakeSplashViewModel: BaseViewModel {
    // MARK: - Private properties
    private let authService: AuthNetworkServiceProtocol
    private let tokenStorage: TokenStorage
    private let userService: UserService
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<FakeSplashTransition, Never>()
    
    // MARK: - Init
    init(authService: AuthNetworkServiceProtocol, tokenStorage: TokenStorage, userService: UserService) {
        self.authService = authService
        self.tokenStorage = tokenStorage
        self.userService = userService
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        guard let token = tokenStorage.token else {
            transitionSubject.send(.didFinish(status: .nonAuthorized))
            return
        }
        transitionSubject.send(.didFinish(status: .authorized))
    }
}
