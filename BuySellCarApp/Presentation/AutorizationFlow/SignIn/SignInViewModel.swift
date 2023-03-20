//
//  SignInViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Combine
import Foundation

enum SignInViewModelEvents {
    case isFieldsValid(Bool)
    case isNicknameValis(Bool)
    case isPasswordValid(Bool)
}

final class SignInViewModel: BaseViewModel {
    // MARK: - Private properties
    private let networkService: AuthNetworkServiceProtocol
    private let userService: UserService
    
    // MARK: - PassthroughSubjects
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SignInTransition, Never>()
    
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<SignInViewModelEvents, Never>()
    
    // MARK: - CurrentValueSubjects
    private let passwordSubject = CurrentValueSubject<String, Never>("")
    private let nicknameSubject = CurrentValueSubject<String, Never>("")
    private let isPasswordValid = CurrentValueSubject<Bool, Never>(false)
    private let isNicknameValid = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Init
    init(networkService: AuthNetworkServiceProtocol, userService: UserService) {
        self.networkService = networkService
        self.userService = userService
        super.init()
    }
    
    // MARK: - LifeCycle
    override func onViewDidLoad() {
        nicknameSubject
            .map { RegEx.email.checkString(text: $0) }
            .dropFirst()
            .removeDuplicates()
            .sink { [unowned self] in eventsSubject.send(.isNicknameValis($0)) }
            .store(in: &cancellables)
        passwordSubject
            .map { RegEx.password.checkString(text: $0) }
            .dropFirst()
            .removeDuplicates()
            .sink { [unowned self] in eventsSubject.send(.isPasswordValid($0)) }
            .store(in: &cancellables)
    }
    
    override func onViewWillAppear() {
        passwordSubject
            .map { RegEx.password.checkString(text: $0) }
            .sink { [unowned self] in isPasswordValid.value = $0 }
            .store(in: &cancellables)
        nicknameSubject
            .map { RegEx.email.checkString(text: $0) }
            .sink { [unowned self] in isNicknameValid.value = $0 }
            .store(in: &cancellables)
        isNicknameValid.combineLatest(isPasswordValid)
            .map { $1 && $0 }
            .sink { [unowned self] in eventsSubject.send(.isFieldsValid($0)) }
            .store(in: &cancellables)
    }
}

// MARK: - Internal extension
extension SignInViewModel {
    func login() {
        isLoadingSubject.send(true)
        networkService.login(loginModel: .init(login: nicknameSubject.value, password: passwordSubject.value))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard case let .failure(error) = error else {
                    return
                }
                
                self?.isLoadingSubject.send(false)
                self?.errorSubject.send(error)
        
            } receiveValue: { [weak self] model in
                guard let self = self else {
                    return
                }
                self.isLoadingSubject.send(false)
                self.userService.saveToken(model.userToken)
                self.userService.saveUser(.init(responseModel: model))
                self.transitionSubject.send(.showMainFlow)
            }
            .store(in: &cancellables)
    }
    
    func setNickname(_ nickname: String) {
        nicknameSubject.send(nickname)
    }
    
    func setPassword(_ password: String) {
        passwordSubject.send(password)
    }
    
    func showCreateAccount() {
        transitionSubject.send(.createAccount)
    }
    
    func showRestorePassword() {
        transitionSubject.send(.restorePassword)
    }
}
