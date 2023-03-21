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
}

final class EditUserProfileViewModel: BaseViewModel {
    // MARK: - Private properties
    private let userService: UserService
    
    // MARK: - Subjects
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<EditUserProfileTransition, Never>()
    
    private(set) lazy var eventsPublisher = eventsSubject.eraseToAnyPublisher()
    private let eventsSubject = PassthroughSubject<EditUserProfileViewModelEvents, Never>()
    
    // MARK: - Init
    init(userService: UserService) {
        self.userService = userService
        super.init()
    }
    
    // MARK: - Life cycle
    override func onViewWillAppear() {
        userService.userDomainPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] userModel in
                guard let userModel = userModel else {
                    return
                }
                eventsSubject.send(.showUserInfo(userModel))
            }
            .store(in: &cancellables)
    }
}

// MARK: - Internal extension
extension EditUserProfileViewModel {
    func logout() {
        isLoadingSubject.send(true)
        userService.logout()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else {
                    return
                }
                switch error {
                case .finished:
                    self.userService.clear()
                    self.isLoadingSubject.send(false)
                    self.transitionSubject.send(.logout)
                case .failure(let error):
                    self.errorSubject.send(error)
                    self.isLoadingSubject.send(false)
                }
            } receiveValue: { _ in }
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
                case .failure(let error):
                    self.isLoadingSubject.send(false)
                    self.errorSubject.send(error)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
