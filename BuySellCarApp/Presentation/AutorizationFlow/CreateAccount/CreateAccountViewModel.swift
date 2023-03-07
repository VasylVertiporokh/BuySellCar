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
    case checkEmail(Bool)
    case checkName(Bool)
    case checkPassword(Bool)
    case comparePasswords(Bool)
    case isAllFieldsValid(Bool)
    case userCreatedSuccessfully
}

final class CreateAccountViewModel: BaseViewModel {
    // MARK: - Private properties
    private let authService: AuthNetworkServiceProtocol
    
    // MARK: - Subjects
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<CreateAccountTransition, Never>()
    
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<CreateAccountViewModelEvents, Never>()
    
    private let nameSubject = CurrentValueSubject<String, Never>("")
    private let emailSubject = CurrentValueSubject<String, Never>("")
    private let passwordSubject = CurrentValueSubject<String, Never>("")
    private let repeatPasswordSubject = CurrentValueSubject<String, Never>("")
    private let isPasswordFieldEquelSubject = CurrentValueSubject<Bool, Never>(false)
    private let isAllFieldsValidSubject = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Init
    init(authService: AuthNetworkServiceProtocol) {
        self.authService = authService
        super.init()
    }
    
    // MARK: - Lifecycle
    override func onViewDidLoad() {
        nameSubject
            .map {  RegEx.nickname.checkString(text: $0) }
            .dropFirst()
            .removeDuplicates()
            .sink { [unowned self] in eventsSubject.send(.checkName($0)) }
            .store(in: &cancellables)
        
        emailSubject
            .map {  RegEx.email.checkString(text: $0) }
            .dropFirst()
            .removeDuplicates()
            .sink { [unowned self] in eventsSubject.send(.checkEmail($0)) }
            .store(in: &cancellables)
        
        passwordSubject
            .map {  RegEx.password.checkString(text: $0) }
            .dropFirst()
            .removeDuplicates()
            .sink { [unowned self] in eventsSubject.send(.checkPassword($0)) }
            .store(in: &cancellables)
        
        repeatPasswordSubject.combineLatest(passwordSubject)
            .map { RegEx.password.checkString(text: $0) && RegEx.password.checkString(text: $1) }
            .dropFirst()
            .removeDuplicates()
            .sink { [unowned self] in
                eventsSubject.send(.comparePasswords($0))
                isPasswordFieldEquelSubject.send($0)
            }
            .store(in: &cancellables)
        isAllFieldsValidSubject
            .combineLatest(nameSubject, emailSubject, isPasswordFieldEquelSubject)
            .map { RegEx.nickname.checkString(text: $1) && RegEx.email.checkString(text: $2) && $3 }
            .sink { [unowned self] in eventsSubject.send(.isAllFieldsValid($0)) }
            .store(in: &cancellables)
    }
}

// MARK: - Internal extension
extension CreateAccountViewModel {
    func createAccount() {
        isLoadingSubject.send(true)
        authService.creteUser(
            userModel: .init(email: emailSubject.value,
                             password: passwordSubject.value,
                             name: nameSubject.value)
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] error in
            guard case let .failure(error) = error else {
                return
            }
            self?.errorSubject.send(error)
            self?.isLoadingSubject.send(false)
        } receiveValue: { [weak self] result in
            guard let self = self else {
                return
            }
            self.isLoadingSubject.send(false)
            self.eventsSubject.send(.userCreatedSuccessfully)
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
}
