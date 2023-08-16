//
//  EmailService.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 15/08/2023.
//

import Foundation
import Combine

protocol EmailService {
    var user: UserDomainModel? { get }
    func sendEmail(emailDomainModel: EmailDomainModel) -> AnyPublisher<Void, Error>
}

final class EmailServiceImpl {
    // MARK: - Internal properties
    var user: UserDomainModel? {
        userService.user
    }
    
    // MARK: - Private properties
    private let emailNetworkService: EmailNetworkService
    private let userService: UserService
    
    // MARK: - Init
    init(emailNetworkService: EmailNetworkService, userService: UserService) {
        self.emailNetworkService = emailNetworkService
        self.userService = userService
    }
}

// MARK: - EmailService
extension EmailServiceImpl: EmailService {
    func sendEmail(emailDomainModel: EmailDomainModel) -> AnyPublisher<Void, Error> {
        emailNetworkService.sendEmail(model: .init(model: emailDomainModel))
            .mapError { $0 as Error }
            .flatMap { [unowned self] model -> AnyPublisher<Void, Error> in
                return emailNetworkService.createEmailRelation(objectId: emailDomainModel.sendingInfo.adsId, emailResponse: model)
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
