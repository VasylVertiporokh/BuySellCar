//
//  UserDefaultsService.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.02.2023.
//

import Foundation
import Combine

final class UserDefaultsServiceImpl: UserDefaultsServiceProtocol {
    // MARK: - Internal properties
    var userID: String? {
        let userID = try? getObject(forKey: .userModel, castTo: UserDomainModel.self).ownerID
        return userID
    }
    
    // MARK: - Private properties
    private let userDefaults = UserDefaults.standard
    // MARK: - Save object
    func saveObject<Object>(_ object: Object, forKey: UserDefaultsServiceKeys) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            userDefaults.set(data, forKey: forKey.rawValue)
        } catch {
            throw UserDefaultsServiceError.unableToEncode
        }
    }
    
    // MARK: - Get object
    func getObject<Object>(forKey: UserDefaultsServiceKeys, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = userDefaults.data(forKey: forKey.rawValue) else {
            throw UserDefaultsServiceError.noValue
        }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw UserDefaultsServiceError.unableToDecode
        }
    }
    
    // MARK: - Remove object for key
    func removeObject(forKey: UserDefaultsServiceKeys) {
        userDefaults.removeObject(forKey: forKey.rawValue)
    }
}

// MARK: - UserDefaultsServiceKeys
enum UserDefaultsServiceKeys: String {
    case userModel = "user"
}
