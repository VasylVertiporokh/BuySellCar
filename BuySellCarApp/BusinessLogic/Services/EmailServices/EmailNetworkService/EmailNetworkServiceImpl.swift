//
//  EmailNetworkServiceImpl.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 15/08/2023.
//

import Foundation
import Combine


final class EmailNetworkServiceImpl<NetworkProvider: NetworkProviderProtocol> where NetworkProvider.Endpoint == EmailEndpointsBuilder {
    // MARK: - Private properties
    private let provider: NetworkProvider
    
    // MARK: - Init
    init(_ provider: NetworkProvider) {
        self.provider = provider
    }
}

// MARK: - EmailNetworkService
extension EmailNetworkServiceImpl: EmailNetworkService {
    func sendEmail(model: EmailRequestModel) -> AnyPublisher<EmailResponseModel, NetworkError> {
        provider.performWithResponseModel(.sendEmail(model))
    }
    
    func createEmailRelation(objectId: String, emailResponse: EmailResponseModel) -> AnyPublisher<Void, NetworkError> {
        let emailId: [String] = [emailResponse.objectId]
        do {
            let data = try JSONSerialization.data(withJSONObject: emailId, options: [])
            return provider.performWithProcessingResult(
                .createRelation(createdEmailData: data, objectId: objectId)
            )
        } catch {
            return Fail(error: NetworkError.unexpectedError)
                .eraseToAnyPublisher()
        }
    }
}
