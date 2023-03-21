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
}
// MARK: - Internal extension
extension SettingsViewModel {
    func showEditProfile() {
        transitionSubject.send(.showEditProfile)
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
