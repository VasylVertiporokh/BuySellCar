//
//  CreateAccountViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.02.2023.
//

import Combine
import Foundation

// MARK: - CreateAccountViewModelEvents
enum CreateAccountViewModelEvents {
    case userCreatedSuccessfully
}

final class CreateAccountViewModel: BaseViewModel {
    // MARK: - Private properties
    private let authService: AuthNetworkServiceProtocol
    private let userService: UserService
    private let tokenStorage: TokenStorage
    private var userPhoneNumber: String = ""
    
    // MARK: - Subjects
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<CreateAccountTransition, Never>()
    
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<CreateAccountViewModelEvents, Never>()
    
    private let nameSubject = CurrentValueSubject<String, Never>("")
    private let emailSubject = CurrentValueSubject<String, Never>("")
    private let passwordSubject = CurrentValueSubject<String, Never>("")
    private let repeatPasswordSubject = CurrentValueSubject<String, Never>("")
    private let isPhoneNumberValidSubject = CurrentValueSubject<Bool, Never>(false)
    
    private let validationSubject = CurrentValueSubject<CreateAccountValidationForm, Never>(.init())
    private(set) lazy var validationPublisher = validationSubject.eraseToAnyPublisher()
    
    // MARK: - Init
    init(authService: AuthNetworkServiceProtocol, userService: UserService, tokenStorage: TokenStorage) {
        self.authService = authService
        self.userService = userService
        self.tokenStorage = tokenStorage
        super.init()
    }
    
    // MARK: - Lifecycle
    override func onViewDidLoad() {
        nameSubject
            .debounce(for: 2, scheduler: RunLoop.main)
            .dropFirst()
            .removeDuplicates()
            .sink { [unowned self] in
                validationSubject.value.name = $0.isEmpty ? .notChecked : ( RegEx.nickname.checkString(text: $0) ? .valid : .invalid )}
            .store(in: &cancellables)
        
        emailSubject
            .debounce(for: 2, scheduler: RunLoop.main)
            .dropFirst()
            .removeDuplicates()
            .sink { [unowned self] in
                validationSubject.value.email = $0.isEmpty ? .notChecked : (RegEx.email.checkString(text: $0) ? .valid : .invalid) }
            .store(in: &cancellables)
        
        passwordSubject
            .debounce(for: 2, scheduler: RunLoop.main)
            .dropFirst()
            .removeDuplicates()
            .sink { [unowned self] in
                validationSubject.value.password = $0.isEmpty ? .notChecked : (RegEx.password.checkString(text: $0) ? .valid : .invalid) }
            .store(in: &cancellables)
        
        repeatPasswordSubject.combineLatest(passwordSubject)
            .debounce(for: 2, scheduler: RunLoop.main)
            .map { $0 == $1 }
            .dropFirst()
            .removeDuplicates()
            .sink { [unowned self] in validationSubject.value.confirmPassword = $0 ? .valid : .invalid }
            .store(in: &cancellables)
        
        isPhoneNumberValidSubject
            .sink { [unowned self] in validationSubject.value.phone = $0 ? .valid : .invalid }
            .store(in: &cancellables)
    }
}

// MARK: - Internal extension
extension CreateAccountViewModel {
    func createAccount() {
        isLoadingSubject.send(true)
        authService.createUserAndLogin(
            userModel: .init(email: emailSubject.value,
                             password: passwordSubject.value,
                             name: nameSubject.value,
                             phoneNumber: userPhoneNumber)
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] error in
            guard case let .failure(error) = error else {
                return
            }
            self?.errorSubject.send(error)
            self?.isLoadingSubject.send(false)
        } receiveValue: { [weak self] userModel in
            guard let self = self else {
                return
            }
            guard let token = userModel.userToken else {
                return
            }
            self.userService.saveUser(.init(responseModel: userModel))
            self.tokenStorage.set(token: Token(value: token))
            self.transitionSubject.send(.showMainFlow)
            
        }
        .store(in: &cancellables)
    }
    
    func backToLogin() {
        transitionSubject.send(.popToRoot)
    }
    
    func setName(_ name: String) {
        nameSubject.send(name)
    }
    
    func setEmail(_ email: String) {
        emailSubject.send(email)
    }
    
    func setPassword(_ password: String) {
        passwordSubject.send(password)
    }
    
    func setRepeatPassword(_ password: String) {
        repeatPasswordSubject.send(password)
    }
    
    func setUserPhone(_ phone: String) {
        userPhoneNumber = phone
    }
    
    func setIsPhoneValid(_ isValid: Bool) {
        isPhoneNumberValidSubject.send(isValid)
    }
}
