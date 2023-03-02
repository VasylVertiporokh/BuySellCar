//
//  SettingsViewModel.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import Combine
import Foundation

final class SettingsViewModel: BaseViewModel {
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SettingsTransition, Never>()
    
    // MARK: - Private properties
    private let userService: UserService
    
    // MARK: - Init
    init(userService: UserService) {
        self.userService = userService
        super.init()
    }
    
    func logout() {
        isLoadingSubject.send(true)
        userService.logout()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                switch error {
                case .finished:
                    self?.userService.deleteUser()
                    self?.isLoadingSubject.send(false)
                    self?.transitionSubject.send(.logout)
                case .failure(let error):
                    self?.errorSubject.send(error)
                    self?.isLoadingSubject.send(false)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
