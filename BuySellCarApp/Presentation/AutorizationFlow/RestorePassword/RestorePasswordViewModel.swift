//
//  RestorePasswordViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 27.02.2023.
//

import Combine
import Foundation

enum RestorePasswordViewModelEvents {
    case isEmailValid(Bool)
}

final class RestorePasswordViewModel: BaseViewModel {
    // MARK: - Private properties
    private let networkService: AuthNetworkServiceProtocol
    
    // MARK: - Subjects
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<RestorePasswordTransition, Never>()
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<RestorePasswordViewModelEvents, Never>()
    private var emailSubject = CurrentValueSubject<String, Never>("")
    
    // MARK: - Init
    init(networkService: AuthNetworkServiceProtocol) {
        self.networkService = networkService
        super.init()
    }
    
    // MARK: - LifeCycle
    override func onViewDidLoad() {
        super.onViewDidLoad()
        emailSubject.sink { [unowned self] value in
            eventsSubject.send(.isEmailValid(RegEx.email.checkString(text: value)))
        }
        .store(in: &cancellables)
    }
}

// MARK: - Internal extension
extension RestorePasswordViewModel {    
    func restorePassword() {
        isLoadingSubject.send(true)
        networkService.restorePassword(userEmail: emailSubject.value)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.isLoadingSubject.send(false)
                    self?.errorSubject.send(error)
                case .finished:
                    self?.closeRestore()
                    self?.isLoadingSubject.send(false)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func closeRestore() {
        transitionSubject.send(.dismiss)
    }
    
    func setUserEmail(_ email: String) {
        emailSubject.send(email)
    }
}
