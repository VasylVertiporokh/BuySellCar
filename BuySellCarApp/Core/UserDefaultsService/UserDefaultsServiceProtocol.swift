//
//  UserDefaultsServiceProtocol.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 28.02.2023.
//

import Foundation
import Combine

// MARK: - UserDefaultsServiceProtocol
protocol UserDefaultsServiceProtocol {    
    func saveObject<Object: Encodable>(_ object: Object, forKey: UserDefaultsServiceKeys) throws
    func getObject<Object: Decodable>(forKey: UserDefaultsServiceKeys, castTo type: Object.Type) throws -> Object
    func removeObject(forKey: UserDefaultsServiceKeys)
}
