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
    @Published private(set) var sections: [SectionModel<SettingsSection, SettingsRow>] = []
    
    // MARK: - Init
    init(userService: UserService) {
        self.userService = userService
        super.init()
    }
        
    override func onViewWillAppear() {
        updateDataSource()
    }
    
    func updateDataSource() {
        guard let user = userService.user else {
            return
        }
        let userProfileSection: SectionModel<SettingsSection, SettingsRow> = {
            let userModel = UserProfileCellModel(
                lastProfileUpdate: user.updated,
                username: user.userName,
                email: user.email,
                avatar: URL(string: user.userAvatar ?? "")
            )
            return .init(section: .userProfile, items: [.userProfile(model: userModel)])
        }()
        
        let userSection: SectionModel<SettingsSection, SettingsRow> = {
            return .init(section: .user, items: [.profile, .notification])
        }()
        
        let feedbackSection: SectionModel<SettingsSection, SettingsRow> = {
            return .init(section: .feedback, items: [.feedback, .recommend])
        }()
        
        let otherSection: SectionModel<SettingsSection, SettingsRow> = {
            return .init(section: .other, items: [
                .outputData,
                .conditionsAgreements,
                .privacyPolicy, .consentProcessing,
                .privacyManager,
                .usedLibraries
            ])
        }()
        self.sections = [userProfileSection, userSection, feedbackSection, otherSection]
    }
}
// MARK: - Internal extension
extension SettingsViewModel {
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
                self.updateDataSource()
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
                    self.updateDataSource()
                case .failure(let error):
                    self.isLoadingSubject.send(false)
                    self.errorSubject.send(error)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
