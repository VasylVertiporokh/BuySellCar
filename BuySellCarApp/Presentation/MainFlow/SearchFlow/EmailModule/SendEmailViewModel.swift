//
//  SendEmailViewModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 14/08/2023.
//

import Foundation
import Combine

final class SendEmailViewModel: BaseViewModel, ObservableObject {
    // MARK: - Internal properties
    @Published var isLoading = false
    @Published var isTradeIn = false
    @Published var name: String = Constant.emptyString
    @Published var email: String = Constant.emptyString
    @Published var phoneNumber: String = Constant.emptyString
    @Published var emailBody: String = Constant.emailBody
    @Published var alert: AlertModel?
    
    // MARK: - Transition publisher
    private(set) lazy var transitionPublisher = transitionSubject.eraseToAnyPublisher()
    private let transitionSubject = PassthroughSubject<SendEmailModuleTransition, Never>()
    
    // MARK: - Private properties
    private let emailService: EmailService
    private let adsDomainModel: AdvertisementDomainModel
    
    // MARK: - Init
    init(adsDomainModel: AdvertisementDomainModel, emailService: EmailService) {
        self.adsDomainModel = adsDomainModel
        self.emailService = emailService
        super.init()
    }
    
    // MARK: - Life cycle - (need fix this)
    override func onViewDidLoad() {
        super.onViewDidLoad()
        setUserInfo()
    }
}

// MARK: - Internal extension
extension SendEmailViewModel {
    func sendEmail() {
        isLoading = true
        let emailDomaiModel = EmailDomainModel(
            emailBody: emailBody,
            senderName: name,
            senderPhoneNumber: phoneNumber,
            senderEmail: email,
            sendingInfo: .init(
                adsId: adsDomainModel.objectID,
                adsName: "\(adsDomainModel.transportName) \(adsDomainModel.transportModel)"
            )
        )
        
        emailService.sendEmail(emailDomainModel: emailDomaiModel)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else {
                    return
                }
                self?.isLoading = false
                self?.alert = .init(title: Localization.error, message: error.localizedDescription)
            } receiveValue: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.isLoading = false
                self.alert = .init(
                    title: Localization.successfullyAlertTitle,
                    message: Localization.letterSentMessage,
                    action: {
                        self.transitionSubject.send(.dismiss)
                    }
                )
            }
            .store(in: &cancellables)
    }
    
    func cancelSending() {
        transitionSubject.send(.dismiss)
    }
}

// MARK: - Private extension
private extension SendEmailViewModel {
    func setUserInfo() {
        guard let user = emailService.user else {
            return
        }
        name = user.userName
        email = user.email
        phoneNumber = user.phoneNumber
    }
}

// MARK: - Constant
private enum Constant {
    static let emailBody: String = "Hello,\n\nI'm interested in your vehicle. Is it still available?\n\nKind regards"
    static let emptyString: String = ""
}
