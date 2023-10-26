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
        
//        guard let token = tokenStorage.token else {
//            transitionSubject.send(.didFinish(status: .nonAuthorized))
//            return
//        }
//
//        authService.validateUserToken(token: token)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] completion in
//                guard case let .failure(error) = completion else {
//                    return
//                }
//                self?.tokenStorage.clear()
//                self?.errorSubject.send(error)
//                self?.transitionSubject.send(.didFinish(status: .nonAuthorized))
//            } receiveValue: { [weak self] isTokenValid in
//                guard isTokenValid else {
//                    self?.tokenStorage.clear()
//                    self?.transitionSubject.send(.didFinish(status: .nonAuthorized))
//                    return
//                }
//                self?.transitionSubject.send(.didFinish(status: .authorized))
//            }
//            .store(in: &cancellables)
        
        guard let token = tokenStorage.token else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.transitionSubject.send(.didFinish(status: .nonAuthorized))
            }
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.transitionSubject.send(.didFinish(status: .authorized))
        }
    }
}
