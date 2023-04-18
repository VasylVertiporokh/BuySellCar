//
//  UserInfoUpdateRequestModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.03.2023.
//

import Foundation

struct UserInfoUpdateRequestModel: Encodable {
    var phoneNumber: String?
    var name: String?
    var userAvatar: String?
    
    init(phoneNumber: String? = nil, name: String? = nil, userAvatar: String? = nil) {
        self.phoneNumber = phoneNumber
        self.name = name
        self.userAvatar = userAvatar
    }
}
