//
//  SignInViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Combine
import Foundation

final class SignInViewModel: BaseViewModel {
    // MARK: - Private properties
    private let networkService: AuthNetworkServiceProtocol
    private let userService: UserService
    private let tokenStorage: TokenStorage
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SignInTransition, Never>()
    
    // MARK: - Validation publisher
    private let validationSubject = CurrentValueSubject<SignInValidationForm, Never>(.init())
    private(set) lazy var validationPublisher = validationSubject.eraseToAnyPublisher()
    
    // MARK: - CurrentValueSubjects
    private let passwordSubject = CurrentValueSubject<String, Never>("")
    private let nicknameSubject = CurrentValueSubject<String, Never>("")
    private let isPasswordValid = CurrentValueSubject<Bool, Never>(false)
    private let isNicknameValid = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Init
    init(networkService: AuthNetworkServiceProtocol, userService: UserService, tokenStorage: TokenStorage) {
        self.networkService = networkService
        self.userService = userService
        self.tokenStorage = tokenStorage
        super.init()
    }
    
    // MARK: - LifeCycle
    override func onViewDidLoad() {
        nicknameSubject
            .dropFirst()
            .debounce(for: 2, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [unowned self] in
                validationSubject.value.email = $0.isEmpty ? .notChecked : (RegEx.email.checkString(text: $0) ? .valid : .invalid)
            }
            .store(in: &cancellables)
        
        passwordSubject
            .dropFirst()
            .debounce(for: 2, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [unowned self] in
                validationSubject.value.password = $0.isEmpty ? .notChecked : (RegEx.password.checkString(text: $0) ? .valid : .invalid)
            }
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
                guard let token = model.userToken else {
                    return
                }
                self.tokenStorage.set(token: Token(value: token))
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
