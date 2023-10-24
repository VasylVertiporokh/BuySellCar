//
//  AuthEndpoitsBuilder.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Foundation

enum AuthEndpoitsBuilder {
    case login(model: LoginRequestModel)
    case createUser(model: CreateUserRequsetModel)
    case restorePassword(email: String)
}

extension AuthEndpoitsBuilder: EndpointBuilderProtocol {
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .createUser:
            return "/users/register"
        case .restorePassword(let userEmail):
            return "/users/restorepassword/\(userEmail)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .createUser:
            return .post
        case .restorePassword:
            return .get
        }
    }
    
    var body: RequestBody? {
        switch self {
        case .login(let model):
            return .encodable(model)
        case .createUser(let model):
            return .encodable(model)
        case .restorePassword:
            return nil
        }
    }
}
