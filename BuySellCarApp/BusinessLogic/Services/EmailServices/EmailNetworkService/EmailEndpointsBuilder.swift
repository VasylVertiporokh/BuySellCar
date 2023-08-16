//
//  EmailEndpointsBuilder.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 15/08/2023.
//

import Foundation

enum EmailEndpointsBuilder {
    case sendEmail(EmailRequestModel)
    case createRelation(createdEmailData: Data, objectId: String)
}

// MARK: - EndpointBuilderProtocol
extension EmailEndpointsBuilder: EndpointBuilderProtocol {
    var path: String {
        switch self {
        case .sendEmail:
            return "/data/Chat"
        case .createRelation(_, let id):
            return "/data/Advertisement/\(id)/adsEmail"
        }
    }
    
    var headerFields: [String : String] {
        switch self {
        case .sendEmail, .createRelation:
            return [
                "Content-Type" : "application/json"
            ]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sendEmail:                           return .post
        case .createRelation:                      return .put
        }
    }
    
    var body: RequestBody? {
        switch self {
        case .sendEmail(let model):                return .encodable(model)
        case .createRelation(let data, _):         return .rawData(data)
        }
    }
}
