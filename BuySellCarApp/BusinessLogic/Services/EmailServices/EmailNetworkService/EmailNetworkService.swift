//
//  EmailNetworkService.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 15/08/2023.
//

import Foundation
import Combine

protocol EmailNetworkService {
    func sendEmail(model: EmailRequestModel) -> AnyPublisher<EmailResponseModel, NetworkError>
    func createEmailRelation(objectId: String, emailResponse: EmailResponseModel) -> AnyPublisher<Void, NetworkError>
}
