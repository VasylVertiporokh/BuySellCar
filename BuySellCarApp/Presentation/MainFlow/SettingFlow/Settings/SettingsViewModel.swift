//
//  SettingsViewModel.swift
//  MVVMSkeleton
//
//

import Combine
import Foundation

final class SettingsViewModel: BaseViewModel {
    // MARK: - Subjects
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SettingsTransition, Never>()
    
    private(set) lazy var sectionsAction = sectionsSubject.eraseToAnyPublisher()
    private let sectionsSubject = CurrentValueSubject<[SectionModel<SettingsSection, SettingsRow>], Never>([])
    
    // MARK: - Private properties
    private let userService: UserService
    
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
        self.sectionsSubject.value = [userProfileSection, userSection, feedbackSection, otherSection]
    }
}
