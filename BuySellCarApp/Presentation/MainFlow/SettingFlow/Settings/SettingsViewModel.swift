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
    @Published private(set) var sections: [SectionModel<SettingsSection, SettingsRow>] = [] // TODO: - Fix it!
    
    // MARK: - Init
    init(userService: UserService) {
        self.userService = userService
        super.init()
    }
    
    override func onViewDidLoad() {
        userService.userDomainPublisher
            .sink { [unowned self] model in
                guard let model = model else {
                    return
                }
                updateDataSource(domainModel: model)
            }
            .store(in: &cancellables)
    }
}
// MARK: - Internal extension
extension SettingsViewModel {
    func showEditProfile() {
        transitionSubject.send(.showEditProfile)
    }
    
    func updateDataSource(domainModel: UserDomainModel) {
        let userProfileSection: SectionModel<SettingsSection, SettingsRow> = {
            let userModel = UserProfileCellModel(
                lastProfileUpdate: domainModel.updated,
                username: domainModel.userName,
                email: domainModel.email,
                avatar: URL(string: domainModel.userAvatar ?? "")
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
