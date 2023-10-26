//
//  EditUserProfileViewModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 20.03.2023.
//

import Combine
import Foundation

enum EditUserProfileViewModelEvents {
    case showUserInfo(UserDomainModel)
    case successfulEditing
}

final class EditUserProfileViewModel: BaseViewModel {
    // MARK: - Private properties
    private let userService: UserService
    private var userUpdateModel = UserInfoUpdateRequestModel()
    
    // MARK: - Subjects
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<EditUserProfileTransition, Never>()
    
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<EditUserProfileViewModelEvents, Never>()
    
    private let validationSubject = CurrentValueSubject<EditProfileValidation, Never>(.init())
    private(set) lazy var validationPublisher = validationSubject.eraseToAnyPublisher()
    
    private let userNameSubject = CurrentValueSubject<String, Never>("")
    private let userPhoneNumber = CurrentValueSubject<String, Never>("")
    private let isPhoneNumberValidSubject = CurrentValueSubject<Bool, Never>(true)
    
    // MARK: - Init
    init(userService: UserService) {
        self.userService = userService
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewDidLoad() {
        userService.userDomainPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] userModel in
                guard let userModel = userModel else {
                    return
                }
                eventsSubject.send(.showUserInfo(userModel))
                userNameSubject.value = userModel.userName
                userPhoneNumber.value = userModel.phoneNumber
            }
            .store(in: &cancellables)
        
        userNameSubject
            .map { RegEx.nickname.checkString(text: $0) }
            .dropFirst()
            .removeDuplicates()
            .sink { [unowned self] in validationSubject.value.name = $0 ? .valid : .invalid }
            .store(in: &cancellables)
        
        isPhoneNumberValidSubject
            .sink { [unowned self] in validationSubject.value.phoneNumber = $0 ? .valid : .invalid}
            .store(in: &cancellables)
    }
}

// MARK: - Internal extension
extension EditUserProfileViewModel {
    func logout() {
        isLoadingSubject.send(true)
        userService.logout()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.isLoadingSubject.send(false)
                self?.errorSubject.send(error)
            } receiveValue: { [weak self] in
                self?.userService.clear()
                self?.isLoadingSubject.send(false)
                self?.transitionSubject.send(.logout)
            }
            .store(in: &cancellables)
    }
    
    func updateUserInfo() {
        guard let userId = userService.user?.objectID else { return }
        userUpdateModel.phoneNumber = userPhoneNumber.value
        userUpdateModel.name = userNameSubject.value
        isLoadingSubject.send(true)
        userService.updateUser(
            userModel: userUpdateModel,
            userId: userId
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self = self else {
                return
            }
            guard case let .failure(error) = completion else {
                return
            }
            self.isLoadingSubject.send(false)
            self.errorSubject.send(error)
        } receiveValue: { [weak self] userModel in
            guard let self = self else {
                return
            }
            self.isLoadingSubject.send(false)
            self.userService.saveUser(.init(responseModel: userModel))
            self.eventsSubject.send(.successfulEditing)
        }
        .store(in: &cancellables)
    }
    
    func updateUserAvatar(_ userAvatar: Data) {
        let multipartItem = MultipartItem(data: userAvatar, attachmentKey: "", fileName: "avatar.png")
        guard let userId = userService.user?.objectID else { return }
        isLoadingSubject.send(true)
        userService.updateAvatar(userAvatar: multipartItem, userId: userId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                guard case let .failure(error) = completion else {
                    return
                }
                self.isLoadingSubject.send(false)
                self.errorSubject.send(error)
            } receiveValue: { [weak self] model in
                guard let self = self else {
                    return
                }
                self.userService.saveUser(.init(responseModel: model))
                self.isLoadingSubject.send(false)
                self.eventsSubject.send(.successfulEditing)
            }
            .store(in: &cancellables)
    }
    
    func deleteAvatar() {
        guard let objectID = userService.user?.objectID else {
            return
        }
        isLoadingSubject.send(true)
        userService.deleteAvatar(userId: objectID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .finished:
                    self.isLoadingSubject.send(false)
                    self.eventsSubject.send(.successfulEditing)
                case .failure(let error):
                    self.isLoadingSubject.send(false)
                    self.errorSubject.send(error)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func setName(_ name: String) {
        userNameSubject.send(name)
    }
    
    func setPhone(_ phone: String, isValid: Bool) {
        userPhoneNumber.send(phone)
        isPhoneNumberValidSubject.send(isValid)
    }
    
    func setIsOwner(_ IsOwner: Bool) {
        userUpdateModel.isCommercialSales = IsOwner
    }
    
    func setWithWhatsAppAccount(_ withAccount: Bool) {
        userUpdateModel.withWhatsAppAccount = withAccount
    }
}
